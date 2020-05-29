//
//  WeatherModelClass.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation


class WeatherModel {
    var CurrentWeather : CurrentWeatherHelperClass!
    var HourlyWeather : [HourlyWeatherHelperClass]!
    var DailyWeather : [DailyWeatherHelperClass]!
    

    
    func fetchDataFromWeatherAPI () {
        NetworDataFetcher.sharedNetworkInstance.fetchWeatherData(lat: 33.684422, lon: 73.047882)
    }
    
    func saveDateInDb(){
        
    }
    
    func updateDataInDb(){
        
    }
    
    func retriveDataFromDb(){
        
    }
}
