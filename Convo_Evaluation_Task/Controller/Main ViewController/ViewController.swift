//
//  ViewController.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 21/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var rootWeatherCollectionView: UICollectionView!
    
    var locationManager : CLLocationManager! /* for managing location related stuff */
    var userLocation : CLLocation! /* for handling current location */
    var latitude: Double = 0.0 //
    var longitude: Double = 0.0
    var weatherModel = WeatherModel()
    let progressHUD = ProgressHUD(text: "")
    var lastUpdatedLabel = UILabel()
    let vibrancyView =  UIVisualEffectView()
    var collectionViewDataSource = rootCollectionViewDataSource() /* data source class for root collection view */
    var collectionViewDelegate = rootCollectionViewDelegate() /* delegate class for root collection view */
    var currentLocalTime : (Int, Int) = (0,0) /* for saving the time user lauched the application */
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //
    //        if CLLocationManager.locationServicesEnabled() {
    //
    //            locationManager.startUpdatingLocation()
    //        }
    //    }
    
    
//    /* tells if the data should be refreshed or not, a minimum of 30 mins are limit to refresh the data */
//    static func shouldUpdateData(localTime: (hour: Int,min: Int), refreshTime: (hour: Int,min: Int)) -> Bool {
//        return (refreshTime.hour - localTime.hour) >= 1 || (refreshTime.min - localTime.min) >= 30
//    }
    
//    /*   returns the current time in hr:min from when called */
//    func getLocalTime() -> (Int,Int){
//        let date = NSDate()
//        let calender = NSCalendar.current
//        let components = calender.dateComponents([.hour, .minute], from: date as Date)
//        return (components.hour!,components.minute!)
//        
//    }
    
     /*  some code that app required offenly so made a func for it */
    func utilityFunction(reloadData: Bool) {
        self.collectionViewDataSource = rootCollectionViewDataSource(weatherModelT: self.weatherModel)
        self.rootWeatherCollectionView.delegate = (self.collectionViewDelegate)
        self.rootWeatherCollectionView.dataSource = (self.collectionViewDataSource)
        if reloadData {
            self.rootWeatherCollectionView.reloadData()
        }
        self.lastUpdatedLabel.text = "Updated at: \(self.weatherModel.getLastUpdatedDataTime())"
    }
    
    
    
    /* function call when collectionView Pulled down */
    @objc func pulledDownFuncCalled(refreshControl: UIRefreshControl){
        self.progressHUD.show()
         /*   app will not fetch data if it already fetched data 20 mins ago */
        if weatherModel.shouldUpdateData(localTime: self.weatherModel.getLocalTime(), refreshTime: self.weatherModel.getFetchedTime())
        {
            self.progressHUD.show()
            self.fetchDataFromModel(refreshBool: false){sucess in
                if sucess {
                    self.progressHUD.hide()
                }
            }
        }
        else {
            utilityFunction(reloadData: true)
        }
//         self.progressHUD.hide()
        refreshControl.endRefreshing()
    }
    
    /* function that fetched data through model class  */
    func fetchDataFromModel(refreshBool: Bool, completeonClosure: @escaping (Bool) -> ())
    {
        self.progressHUD.show()
        if self.checkInternetConnection() == 2 || self.checkInternetConnection() == 3
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
            {
                self.weatherModel.DeleteAllDataFromDb()
                DispatchQueue.background(delay: 2 ,background:
                    {
                        self.weatherModel.fetchDataFromWeatherAPI()
                            {
                                sucess in
                                if sucess
                                {
                                    self.utilityFunction(reloadData: true)
                                    self.weatherModel.saveDateInDb()
                                    completeonClosure(sucess)
                                }
                        }
                }
                )
            }
             /*   display data from database untill new data is fetched, which is being fetched in background thread*/
            if !refreshBool
            {
                self.weatherModel.retriveDataFromDb()
                utilityFunction(reloadData: true)
                completeonClosure(false)
            }
        }else
        {
            self.progressHUD.hide()
            self.weatherModel.retriveDataFromDb()
            utilityFunction(reloadData: false)
            completeonClosure(false)
        }
    }
    
    /* for adding a location managerIcon along with its target function  */
    func addLocationManagerIcon(){
        let locationIcon = UIImageView(frame: CGRect(x: self.view.frame.minX + 15 , y: self.view.frame.minY  + 60 , width: self.view.frame.width / 13 , height: self.view.frame.width / 11 ))
        locationIcon.image = UIImage(named: "location")
        self.view.addSubview(locationIcon)
    }
    
    /* for adding a green check when data is fetched initially */
    func addGreenCheck(){
        let imageView = UIImageView(frame: CGRect(x: self.progressHUD.frame.minX + 2, y: self.progressHUD.frame.minY + 7, width: self.progressHUD.frame.width / 1.5 , height: self.progressHUD.frame.width / 1.5))
        imageView.image = UIImage(named: "greenCheck")
        self.view.addSubview(imageView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            imageView.removeFromSuperview()
        }
    }
    
    /* for adding a UIView at the top */
    func addUIView(){
        let uiview = UIView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY + 40 , width: self.view.frame.width, height: self.view.frame.width / 6 ))
        uiview.backgroundColor = #colorLiteral(red: 0.3640545684, green: 0.2428080664, blue: 0.3289214868, alpha: 1)
        self.view.addSubview(uiview)
    }
    
    /* for adding a ui label for last refreshed */
    func addLastRefreshed()
    {
        lastUpdatedLabel = UILabel(frame: CGRect(x: self.view.frame.maxX - ((self.view.frame.width / 3.45)) , y: self.view.frame.minY + 65 , width: (self.view.frame.width / 3) + 3 , height: self.view.frame.width / 11 ))
        lastUpdatedLabel.text = "Updated at: \(weatherModel.getLastUpdatedDataTime())"
        lastUpdatedLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lastUpdatedLabel.font = lastUpdatedLabel.font.withSize(14)
        self.view.addSubview(lastUpdatedLabel)
    }
    
    /* for adding a refresh control  */
    func addRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledDownFuncCalled), for: .valueChanged)
        self.rootWeatherCollectionView.refreshControl = refreshControl
        self.view.addSubview(progressHUD)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootWeatherCollectionView.backgroundColor = #colorLiteral(red: 0.3616552982, green: 0.2405221771, blue: 0.3134187302, alpha: 0.7786012414)
        DispatchQueue.main.async {
            self.rootWeatherCollectionView.collectionViewLayout.invalidateLayout()
        }
        self.weatherModel = WeatherModel()
        self.collectionViewDataSource = rootCollectionViewDataSource(weatherModelT: self.weatherModel)
        self.rootWeatherCollectionView.delegate = (self.collectionViewDelegate)
        self.rootWeatherCollectionView.dataSource = (self.collectionViewDataSource)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.weatherModel.context = appDelegate.persistentContainer.viewContext
        self.addUIView()
        self.addLocationManagerIcon()
        self.addLastRefreshed()
        self.addRefreshControl()
        self.collectionViewDataSource = rootCollectionViewDataSource(weatherModelT: self.weatherModel)
        self.fetchDataFromModel(refreshBool: false){
            Sucess in
            if Sucess{
                self.progressHUD.hide()
                self.addGreenCheck()
            }
            else {
                self.utilityFunction(reloadData: false)
            }
        }
        self.locationManager = CLLocationManager()
        self.userLocation = CLLocation()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() == false
        {
            print("No permissions!")
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    /* function to check internet connectivity  */
    func checkInternetConnection() -> Int{
        let status = Reach().connectionStatus()
        var returnStatus = 0
        switch status {
        case .unknown, .offline:
            returnStatus = 1//print("Not connected")
        case .online(.wwan):
            returnStatus = 2//print("Connected via WWAN")
        case .online(.wiFi):
            returnStatus = 3//print("Connected via WiFi")
        }
        return returnStatus
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while requesting new coordinates")
    }
    
    
    /* updates user location  */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0]
        let distance = userLocation.distance(from: newLocation)
        // using this to update my location every 100m
        if distance > 100 {
            userLocation = newLocation
        }
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    
    
    /* function to function for enable User location  */
    func enableLocationPermission()
    {
        let locStatus = CLLocationManager.authorizationStatus()
        switch locStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            print("Not known")
        }
    }
    
}


/* an extension to for background Process  */
extension DispatchQueue
{
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
extension UINavigationController {
    
    func setStatusBarColor(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
    
}

