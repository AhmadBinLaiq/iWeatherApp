//
//  HourlyWeatherModel.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation

class HourlyWeatherHelperClass{
    var time : String = ""
    var temperature : Float = 0.0
    var iconName : String = ""
    
    init(time : String, temperature : Float,iconName : String) {
        self.time = time
        self.temperature = temperature - 273.15
        self.iconName = iconName
    }
    
    func getHourlyWeather() -> (String,Float,String){
        return (time,temperature,iconName)
    }
    
}
