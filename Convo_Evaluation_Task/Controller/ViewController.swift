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
    
    var locationManager : CLLocationManager!
    var userLocation : CLLocation!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var weatherModel : WeatherModel!

    override func viewWillAppear(_ animated: Bool) {
        print("Im called 2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
         print("Im called 4")
        if CLLocationManager.locationServicesEnabled() {
                    print("Im called 5")
//                    self.enableLocationPermission()
                    locationManager.startUpdatingLocation()
                }
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Im called 1")
        weatherModel = WeatherModel()
        weatherModel.fetchDataFromWeatherAPI();
//        determineMyCurrentLocation()
        locationManager = CLLocationManager()
//         enableLocationPermission()
        userLocation = CLLocation()
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
        checkInternetConnection()
        if CLLocationManager.locationServicesEnabled() == false {
            print("No permissions!")
//            enableLocationPermission()
            locationManager.requestAlwaysAuthorization()
            
        }
    }
    
    
    func checkInternetConnection(){
        let status = Reach().connectionStatus()

        switch status {
        case .unknown, .offline:
            print("Not connected")
        case .online(.wwan):
            print("Connected via WWAN")
        case .online(.wiFi):
            print("Connected via WiFi")
        }
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error while requesting new coordinates")
        }


 
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
//
    
    
//    func fetchWeatherData()  {
//          //           https://api.openweathermap.org/data/2.5/onecall?lat=33.441792&lon=-94.037689&
//          //        exclude=hourly,daily&appid={YOUR API KEY
//          //            http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=
//          Alamofire.request("https://api.openweathermap.org/data/2.5/onecall?lat=33.441792&lon=-94.037689&exclude=minutely&appid=6a353f13b6d49a84fad1e63de6135d9a").responseJSON { (responseData) -> Void in
//              if((responseData.result.value) != nil) {
//                  let swiftyJsonVar = JSON(responseData.result.value!)
//                  print(swiftyJsonVar)
//              }
//          }
//      }
//
    
    
    func enableLocationPermission() // function for enable User location
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


        }
    }
//
//
}

