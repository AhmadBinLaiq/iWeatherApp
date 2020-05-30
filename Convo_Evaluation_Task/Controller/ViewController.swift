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
    let progressHUD = ProgressHUD(text: "Fetching Data")
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
    
    
    /* tells if the data should be refreshed or not, a minimum of 30 mins are limit to refresh the data */
    static func shouldUpdateData(localTime: (hour: Int,min: Int), refreshTime: (hour: Int,min: Int)) -> Bool {
        return (refreshTime.hour - localTime.hour) >= 1 || (refreshTime.min - localTime.min) >= 30
    }
    
    /*   returns the current time in hr:min from when callde */
    func getLocalTime() -> (Int,Int){
        let date = NSDate()
        let calender = NSCalendar.current
        let components = calender.dateComponents([.hour, .minute], from: date as Date)
        return (components.hour!,components.minute!)
        
    }
    
    func utilityFunction() {
        
    }
    
    /* function all when collectionView Pulled down */
    @objc func pulledDownFuncCalled(refreshControl: UIRefreshControl){
        print("Last updated:  ",weatherModel.getCurrentWeatherData().getLastUpdated())
        print("Time 2:: ", self.getLocalTime())
        print(" !========================================== Refreshed ==========================================!")
        print("Going IN 1")
        if WeatherModel.shouldUpdateData(localTime: self.weatherModel.getFetchedTime(), refreshTime: self.getLocalTime())
        {
            print("Updatinggggggggggg------------------------------")
            self.fetchDataFromModel(refreshBool: true)
        }
        else {
            print("did not Updatinggggggggggg------------------------------")
            self.collectionViewDataSource = rootCollectionViewDataSource(weatherModelT: self.weatherModel)
            self.rootWeatherCollectionView.delegate = (self.collectionViewDelegate)
            self.rootWeatherCollectionView.dataSource = (self.collectionViewDataSource)
            self.rootWeatherCollectionView.reloadData()
            refreshControl.endRefreshing()
        }
        print("im out 3")
        print("Job done 4")
    }
    
    /* function that fetched data through model class  */
    func fetchDataFromModel(refreshBool: Bool, completeonClosure:  ((Bool) -> ())? = nil){
        //        if refreshBool{
        //
        //        }
        //        else {
        //
        //        }
        
        if self.checkInternetConnection() == 2 || self.checkInternetConnection() == 3
        {
            
            print("staying IN 2 ")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
            {
                
                self.weatherModel.DeleteAllDataFromDb()
                print("Internet Connected")
                print("staying IN 2a ")
                //            }
                DispatchQueue.background(delay: 2 ,background:
                    {
                        self.weatherModel.fetchDataFromWeatherAPI()
                            {
                                ifSucess in
                                if ifSucess
                                {
                                    print("ahahhahhahahahhahahahahah--------------------------------------------")
                                    
                                    self.collectionViewDataSource = rootCollectionViewDataSource(weatherModelT: self.weatherModel)
                                    self.rootWeatherCollectionView.delegate = (self.collectionViewDelegate)
                                    self.rootWeatherCollectionView.dataSource = (self.collectionViewDataSource)
                                    
                                    self.weatherModel.saveDateInDb()
                                    self.rootWeatherCollectionView.reloadData()
                                    self.rootWeatherCollectionView.refreshControl!.endRefreshing()
                                    completeonClosure!(ifSucess)
                                }
                        }
                        
                        print("leaving 2a(1)")
                }
                 )
                
            }
            if !refreshBool
            {
                self.weatherModel.retriveDataFromDb()
                self.collectionViewDataSource = rootCollectionViewDataSource(weatherModelT: self.weatherModel)
                self.rootWeatherCollectionView.delegate = (self.collectionViewDelegate)
                self.rootWeatherCollectionView.dataSource = (self.collectionViewDataSource)
                self.rootWeatherCollectionView.reloadData()
                self.rootWeatherCollectionView.refreshControl!.endRefreshing()
            }
            //
        }
            
        else
        {
            print("staying IN 2b ")
            print("Internet Not Connected") // fetched time should be updated according to current - time in database!
            self.weatherModel.retriveDataFromDb()
            self.collectionViewDataSource = rootCollectionViewDataSource(weatherModelT: self.weatherModel)
            self.rootWeatherCollectionView.delegate = (self.collectionViewDelegate)
            self.rootWeatherCollectionView.dataSource = (self.collectionViewDataSource)
            self.rootWeatherCollectionView.refreshControl!.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootWeatherCollectionView.backgroundColor = #colorLiteral(red: 0.3616552982, green: 0.2405221771, blue: 0.3134187302, alpha: 0.7786012414)
        self.weatherModel = WeatherModel()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.weatherModel.context = appDelegate.persistentContainer.viewContext
        let locationIcon = UIImageView(frame: CGRect(x: self.view.frame.minX + 15 , y: self.view.frame.minY  + 60 , width: self.view.frame.width / 13 , height: self.view.frame.width / 11 ))
        locationIcon.image = UIImage(named: "location")
        self.view.addSubview(locationIcon)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledDownFuncCalled), for: .valueChanged)
        self.rootWeatherCollectionView.refreshControl = refreshControl
        
        
        self.view.addSubview(progressHUD)
        self.progressHUD.show()
        
        
        self.collectionViewDataSource = rootCollectionViewDataSource(weatherModelT: self.weatherModel)
        self.currentLocalTime = getLocalTime()
        self.fetchDataFromModel(refreshBool: false){
            Sucess in
            if Sucess{
                self.progressHUD.hide()
                let imageView = UIImageView(frame: CGRect(x: self.progressHUD.frame.minX, y: self.progressHUD.frame.minY, width: self.progressHUD.frame.width / 2 , height: self.progressHUD.frame.width / 2))
                imageView.image = UIImage(named: "greenCheck")
                self.view.addSubview(imageView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                {
                    imageView.removeFromSuperview()
                }
                
            }
        }
        print("Im back 5")
        self.locationManager = CLLocationManager()
        self.userLocation = CLLocation()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() == false {
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
extension DispatchQueue {

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

