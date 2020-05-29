//
//  DailyWeatherModel.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation

class DailyWeatherHelperClass {
    var weekday : String = ""
    var lowTemp : Float = 0.0
    var highTemp : Float = 0.0
    var iconName : String = ""
    
    init(weekday : String, lowTemp : Float,highTemp : Float,iconName : String) {
        self.weekday = weekday
        self.lowTemp = lowTemp - 273.15
        self.highTemp = highTemp - 273.15
        self.iconName = iconName
        
    }
    
    

    
}
