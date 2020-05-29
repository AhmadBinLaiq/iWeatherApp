//
//  CurrentWeatherModel.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation



class CurrentWeatherHelperClass {
    
    // all temp must be in Centigrate
    
    var city : String = ""
    var weatherStatus : String = ""
    var temperature : Float = 0.0
    var lowTemp : Float = 0.0
    var highTemp : Float = 0.0
    var weekDay: String = ""
    var sunRiseTime : String = ""
    var sunSetTime : String = ""
    var humidity : String = ""
    var wind : String = ""
    var feelsLike : Float = 0.0
    var precipitation : String = ""
    var pressure : String = ""
    var visibilty : String = ""
    var uvIndex : String = ""
    var airQualityIndex : String = ""
    var airQuality : String = ""
    
     init(cityF : String,weatherStatusF : String,temperatureF : Float,lowTempF : Float,highTempF : Float,weekDayF: String,sunRiseTimeF : String,sunSetTimeF : String, humidityF : String,windF : String,feelsLikeF : Float,precipitationF : String,pressureF : String,visibiltyF : String,uvIndexF : String,airQualityIndexF : String,airQualityF : String) {
        city = cityF
        weatherStatus = weatherStatusF
        temperature = temperatureF - 273.15
        lowTemp = lowTempF - 273.15
        highTemp = highTempF - 273.15
        weekDay = weekDayF
        sunSetTime = sunSetTimeF
        sunRiseTime = sunRiseTimeF
        humidity = humidityF
        wind = windF
        feelsLike = feelsLikeF
        precipitation = precipitationF
        pressure = pressureF
        visibilty = visibiltyF
        uvIndex = uvIndexF
        airQualityIndex = airQualityIndexF
        airQuality = airQualityF
        
    }
    
}


