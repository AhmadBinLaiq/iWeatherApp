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
    private var fetchTime : String = ""
    private var city : String = ""
    private var weatherStatus : String = ""
    private var temperature : Float = 0.0
    private var lowTemp : Float = 0.0
    private var highTemp : Float = 0.0
    private var weekDay: String = ""
    private var sunRiseTime : String = ""
    private var sunSetTime :  String = ""
    private var humidity : String = ""
    private var wind : String = ""
    private var feelsLike : Float = 0.0
    private var pressure : String = ""
//    private var visibilty : String = ""
    private var degree : String = ""
    private var weekDays = ["","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    init(){
        
    }
   
    
    init(fetchTimeF: String, cityF : String,weatherStatusF : String,temperatureF : Float,lowTempF : Float,highTempF : Float,weekDayF: String,sunRiseTimeF : String,sunSetTimeF : String, degreeF: String,humidityF : String,windF : String,feelsLikeF : Float,pressureF : String)
    {
           fetchTime = fetchTimeF
           city = cityF
           weatherStatus = weatherStatusF
           temperature = temperatureF
           lowTemp = lowTempF
           highTemp = highTempF
           weekDay = weekDayF
           sunRiseTime = sunRiseTimeF
           sunSetTime = sunSetTimeF
           humidity = humidityF
           wind = windF
           feelsLike = feelsLikeF
           pressure = pressureF
           degree = degreeF
           
       }
    
    private func getDayOfWeek(_ today:String) -> Int? {
           let formatter  = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           guard let todayDate = formatter.date(from: today) else { return nil }
           let myCalendar = Calendar(identifier: .gregorian)
           let weekDay = myCalendar.component(.weekday, from: todayDate)
           return weekDay
       }
       
    
    func getCurrentWeatherData() -> CurrentWeatherHelperClass {
        let temp = CurrentWeatherHelperClass(fetchTimeF: getFetchTime(), cityF: getCity(), weatherStatusF: getWeatherStatus(), temperatureF: Float(getTemperature()), lowTempF: Float(getLowTemp()), highTempF: Float(getHighTemp()), weekDayF: getWeekDay(), sunRiseTimeF: getSunRiseTime(), sunSetTimeF: getSunSetTime(), degreeF: getDegree(), humidityF: getHumidity(), windF: getWind(), feelsLikeF: Float(getFeelsLike()), pressureF: getPressure())
        return temp
        
    }
    
    /*   returns the current time in hr:min from when callde */
         open func getLocalTime() -> (Int,Int){
             let date = NSDate()
             let calender = NSCalendar.current
             let components = calender.dateComponents([.hour, .minute], from: date as Date)
             return (components.hour!,components.minute!)
             
         }
    
    func getLastUpdated() -> Int{
        if getFetchTime() != "" {
           let time = getFetchTime()
           let ret = time.components(separatedBy: ":")
            print("Time remaining: ",(Int(ret[1]))! - getLocalTime().1)
           return (getLocalTime().1 - Int(ret[1])!)
        }
        else {
            print("Called this one")
        return 0
        }
              
    }
       
    
    func getFetchTime() -> String{
        print("Fetch Time is :::",fetchTime)
        return fetchTime
    }
    
    func getCity() -> (String) {
        return (city)
    }
    
    func getWeatherStatus() -> String {
        return (weatherStatus)
    }
    
    func getTemperature() -> (Int) {
        return Int(round(temperature))
    }
    
    func getLowTemp() -> (Int) {
        return Int(round(lowTemp))
    }
    
    func getHighTemp() -> (Int) {
        return Int(round(highTemp))
    }
    
    func getWeekDay() -> (String) {
        if weekDay != ""  && !weekDay.contains("day"){
            let fullNameArr : [String] = weekDay.components(separatedBy: " ")
            self.weekDay = weekDays[getDayOfWeek(fullNameArr[0])!]
        }
        
        return (weekDay)
    }
    
    func getSunSetTime() -> (String) {
        return (unixToTime(unixTime: sunSetTime))
    }
    
    func getSunRiseTime() -> (String) {
        return (unixToTime(unixTime: sunRiseTime))
    }
    
    func getHumidity() -> (String) {
        return (humidity)
    }
    
    func getWind() -> (String) {
        return (wind)
    }
    
    func getFeelsLike() -> (Int) {
        return Int(round(feelsLike))
    }
    
    func getPressure() -> (String) {
        return (pressure)
    }
    
    func getDegree() -> String
    {
        return degree
    }

    private func unixToTime(unixTime: String) -> String {
        var returnString : String
        if unixTime.contains("15"){
            returnString =  stringFromDate(Date(timeIntervalSince1970: Double(unixTime) ?? 0000000000))
            let timeT =  returnString.components(separatedBy: " ")
            returnString =  timeT[3]
        }
        else {
            returnString = unixTime
        }
        return returnString
    }
    
    private func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy HH:mm" //yyyy
        return formatter.string(from: date)
    }
    
}


