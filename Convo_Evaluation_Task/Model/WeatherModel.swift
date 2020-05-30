//
//  WeatherModelClass.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData



class WeatherModel {
    private var currentWeather = CurrentWeatherHelperClass() //big change
    private var hourlyWeather =  [HourlyWeatherHelperClass]()
    private var dailyWeather = [DailyWeatherHelperClass]()
    private let currentWeatherIndex = 0
    private var swiftyJsonVar = JSON()
    var context = NSManagedObjectContext()
    
    func saveDateInDb(){
        saveCurrentWeatherDataInDb()
        saveHourlyWeatherDataInDb()
        saveDailyWeatherDataInDb()
        
    }
    
    func retriveDataFromDb(){
        retriveCurrentWeatherDataFromDb()
        retriveHourlyWeatherDataFromDb()
        retriveDailyWeatherDataFromDb()
        
    }
    
    private func startDataPopulation(){
        self.populateCurrentWeatherData()
        self.populateHourlyWeatherData()
        self.populateWeaklyWeatherData()
    }
    
    func getCurrentWeatherData() -> CurrentWeatherHelperClass {
        return self.currentWeather
    }
    
    
    func getHourlyWeatherData () -> [HourlyWeatherHelperClass] {
        return self.hourlyWeather
    }
    
    
    func getDailyWeatherData () -> [DailyWeatherHelperClass] {
        return self.dailyWeather
    }
    
    
    private func populateHourlyWeatherData(){
        for index in 1...10 {
            let item = HourlyWeatherHelperClass(time: self.swiftyJsonVar["list"][index]["dt_txt"].stringValue, temperature: self.swiftyJsonVar["list"][index]["main"]["temp"].floatValue - 273.15, iconName: self.swiftyJsonVar["list"][index]["weather"][self.currentWeatherIndex]["icon"].stringValue)
            item.setNewValue(val: index)
            self.hourlyWeather.append(item)
        }
    }
    
    private func populateWeaklyWeatherData(){
        var highTempA : Float = 0.0
        var lowTempA : Float = 0.0
        for index in 8...40{
            highTempA += self.swiftyJsonVar["list"][index]["main"]["temp_max"].floatValue
            lowTempA += self.swiftyJsonVar["list"][index]["main"]["temp_min"].floatValue
        }
        
        highTempA = highTempA/32
        lowTempA = lowTempA/32
        print("highTempA: ",highTempA,"lowTempA: ",lowTempA)
        
        for index in 1...4 {
            let item = DailyWeatherHelperClass(weekday: self.swiftyJsonVar["list"][index*8]["dt_txt"].stringValue, lowTemp:  (self.swiftyJsonVar["list"][index*8]["main"]["temp_min"].floatValue - 273.15), highTemp: (self.swiftyJsonVar["list"][index*8]["main"]["temp_max"].floatValue - 273.15), iconName: self.swiftyJsonVar["list"][index*8]["weather"][self.currentWeatherIndex]["icon"].stringValue)
            item.setNewValue(val: index)
            self.dailyWeather.append(item)
        }
        print(self.dailyWeather[3].getDailyData())
        let item = DailyWeatherHelperClass(weekday: (self.swiftyJsonVar["list"][39]["dt_txt"].stringValue), lowTemp: (self.swiftyJsonVar["list"][39]["main"]["temp_min"].floatValue - 273.15), highTemp: (self.swiftyJsonVar["list"][39]["main"]["temp_max"].floatValue - 273.15), iconName: self.swiftyJsonVar["list"][39]["weather"][self.currentWeatherIndex]["icon"].stringValue)
        
        item.setNewValue(val: 5)
        self.dailyWeather.append(item)
        item.changeWeekDate()
    }
    
    private func populateCurrentWeatherData(){
        
        self.currentWeather = CurrentWeatherHelperClass(
            fetchTimeF: "\(getLocalTime().0):\(getLocalTime().1)", cityF:self.swiftyJsonVar["city"]["name"].stringValue , weatherStatusF: self.swiftyJsonVar["list"][self.currentWeatherIndex]["weather"][self.currentWeatherIndex]["main"].stringValue, temperatureF: (self.swiftyJsonVar["list"][self.currentWeatherIndex]["main"]["temp"].floatValue - 273.15), lowTempF: (self.swiftyJsonVar["list"][self.currentWeatherIndex]["main"]["temp_min"].floatValue - 273.15), highTempF: (self.swiftyJsonVar["list"][self.currentWeatherIndex]["main"]["temp_max"].floatValue - 273.15), weekDayF: self.swiftyJsonVar["list"][self.currentWeatherIndex]["dt_txt"].stringValue, sunRiseTimeF:
            self.swiftyJsonVar["city"]["sunrise"].stringValue, sunSetTimeF:self.swiftyJsonVar["city"]["sunset"].stringValue, degreeF: self.swiftyJsonVar["list"][self.currentWeatherIndex]["wind"]["deg"].stringValue, humidityF: self.swiftyJsonVar["list"][self.currentWeatherIndex]["main"]["humidity"].stringValue, windF: self.swiftyJsonVar["list"][self.currentWeatherIndex]["wind"]["speed"].stringValue, feelsLikeF: (self.swiftyJsonVar["list"][self.currentWeatherIndex]["main"]["feels_like"].floatValue - 273.15), pressureF: self.swiftyJsonVar["list"][self.currentWeatherIndex]["main"]["pressure"].stringValue)
        
    }
    
    
    func getFetchedTime() -> (Int,Int){
        if currentWeather.getFetchTime() != ""
        {
            let time = currentWeather.getFetchTime()
            let ret = time.components(separatedBy: ":")
            print("Time",((Int(ret[0]))!,(Int(ret[1]))!))
            return ((Int(ret[0]))!,(Int(ret[1]))!)
        }
        return (0,0)
    }
    
    func getLastUpdatedDataTime() -> String {
        if currentWeather.getFetchTime() != ""
        {
            let time = currentWeather.getFetchTime()
            var ret = time.components(separatedBy: ":")
            if Int(ret[1])! < 10 {
                ret[1] = "0"+ret[1]
            }
            return ("\(ret[0]):\(ret[1])")
        }
        return currentWeather.getFetchTime()
    }
    
    func DeleteAllDataFromDb()
    {
        var DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentWeather"))
        do {
            try context.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
        DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "DailyWeather"))
        do {
            try context.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
        DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "HourlyWeather"))
        do {
            try context.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
    
    
    /*   returns the current time in hr:min from when callde */
    open func getLocalTime() -> (Int,Int){
        let date = NSDate()
        let calender = NSCalendar.current
        let components = calender.dateComponents([.hour, .minute], from: date as Date)
        return (components.hour!,components.minute!)
        
    }
    
    
    /* tells if the data should be refreshed or not, a minimum of 20 mins are limit to refresh the data */
    func shouldUpdateData(localTime: (hour: Int,min: Int), refreshTime: (hour: Int,min: Int)) -> Bool {
        return (localTime.hour - refreshTime.hour) >= 1 || (localTime.min - refreshTime.min) >= 20
    }
    
    
    //    func shouldUpdateData(localTime: (hour: Int,min: Int), refreshTime: (hour: Int,min: Int)) -> Bool {
    //        return check
    //    }
    
    func clearPreviousLocalData(){
        self.currentWeather = CurrentWeatherHelperClass(fetchTimeF: "", cityF: "", weatherStatusF: "", temperatureF: 0.0, lowTempF: 0.0, highTempF: 0.0, weekDayF: "", sunRiseTimeF: "", sunSetTimeF: "", degreeF: "", humidityF: "", windF: "", feelsLikeF: 0.0, pressureF: "")
        self.dailyWeather = []
        self.hourlyWeather = []
    }
    
    func fetchDataFromWeatherAPI(completeonClosure: @escaping (Bool) -> ()) {
        clearPreviousLocalData()
        NetworDataFetcher.sharedNetworkInstance.fetchWeatherData(lat: 33.684422, lon: 73.047882){
            returnJSON,ifSucess in
            self.swiftyJsonVar = returnJSON!
            if ifSucess {
                self.startDataPopulation()
            }
            completeonClosure(ifSucess)
        }
    }
    
    private func saveCurrentWeatherDataInDb()
    {
        let entity =  NSEntityDescription.entity(forEntityName: "CurrentWeather", in: context)
        let currentWeaterData = NSManagedObject(entity: entity!, insertInto: context)
        currentWeaterData.setValue(currentWeather.getFetchTime(), forKey: "fetchTime")
        currentWeaterData.setValue(currentWeather.getCity(), forKey: "city")
        currentWeaterData.setValue(currentWeather.getDegree(), forKey: "degree")
        currentWeaterData.setValue(currentWeather.getFeelsLike(), forKey: "feelsLike")
        currentWeaterData.setValue(currentWeather.getHighTemp(), forKey: "highTemp")
        currentWeaterData.setValue(currentWeather.getHumidity(), forKey: "humidity")
        currentWeaterData.setValue(currentWeather.getLowTemp(), forKey: "lowTemp")
        currentWeaterData.setValue(currentWeather.getPressure(), forKey: "pressure")
        currentWeaterData.setValue(currentWeather.getSunRiseTime(), forKey: "sunRiseTime")
        currentWeaterData.setValue(currentWeather.getSunSetTime(), forKey: "sunSetTime")
        currentWeaterData.setValue(currentWeather.getTemperature(), forKey: "temperature")
        currentWeaterData.setValue(currentWeather.getWeatherStatus(), forKey: "weatherStatus")
        currentWeaterData.setValue(currentWeather.getWeekDay(), forKey: "weekDay")
        currentWeaterData.setValue(currentWeather.getWind(), forKey: "wind")
        do {
            try context.save()
        } catch {
            print("Failed saving current Weather data")
        }
        
    }
    
    
    private func saveHourlyWeatherDataInDb()
    {
        let entity =  NSEntityDescription.entity(forEntityName: "HourlyWeather", in: context)
        for hourlyData in hourlyWeather{
            let hourlyWeatherData = NSManagedObject(entity: entity!, insertInto: context)
            hourlyWeatherData.setValue(hourlyData.getConsistancyIndex(), forKey: "consistancyIndex")
            hourlyWeatherData.setValue(hourlyData.getTemp(), forKey: "temperature")
            hourlyWeatherData.setValue(hourlyData.getTime(), forKey: "time")
            hourlyWeatherData.setValue(hourlyData.getTemp(), forKey: "temperature")
            if let img = hourlyData.getIcon() as? UIImage {
                let data = img.pngData() as NSData?
                hourlyWeatherData.setValue(data, forKey: "hourWeatherIcon")
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed saving hourly weather Data")
        }
    }
    
    
    
    private func saveDailyWeatherDataInDb()
    {
        let entity =  NSEntityDescription.entity(forEntityName: "DailyWeather", in: context)
        for dailyData in dailyWeather {
            let dailyWeatherData = NSManagedObject(entity: entity!, insertInto: context)
            dailyWeatherData.setValue(dailyData.getConsistancyIndex(), forKey: "consistancyIndex")
            dailyWeatherData.setValue(dailyData.getWeekDay(), forKey: "weekday")
            dailyWeatherData.setValue(dailyData.getLowTemp(), forKey: "lowTemp")
            dailyWeatherData.setValue(dailyData.getHighTemp(), forKey: "highTemp")
            if let img = dailyData.getIcon() as? UIImage {
                let data = img.pngData() as NSData?
                dailyWeatherData.setValue(data, forKey: "dailyWeatherIcon")
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed saving daily weather data")
        }
    }
    
    private func setCurrentWeatherData(data: CurrentWeatherHelperClass){
        self.currentWeather = data
        print(self.currentWeather.getCurrentWeatherData())
    }
    
    private func setDailyWeatherData(data: [DailyWeatherHelperClass]){
        for index in data {
            self.dailyWeather.append(index)
            
        }
        self.dailyWeather = self.dailyWeather.sorted(by: { $0.getConsistancyIndex() < $1.getConsistancyIndex() })
    }
    
    private func setHourlyWeatherData(data: [HourlyWeatherHelperClass]){
        for index in data {
            self.hourlyWeather.append(index)
            
        }
        self.hourlyWeather = self.hourlyWeather.sorted(by: { $0.getConsistancyIndex() < $1.getConsistancyIndex() })
    }
    
    
    private func retriveCurrentWeatherDataFromDb(){
        let currentFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentWeather")
        do {
            let currentResult = try context.fetch(currentFetchRequest)
            var temp = CurrentWeatherHelperClass()
            
            for data in currentResult as! [NSManagedObject]
            {
                temp = CurrentWeatherHelperClass(fetchTimeF: data.value(forKey: "fetchTime") as! String, cityF: data.value(forKey: "city") as! String, weatherStatusF: data.value(forKey: "weatherStatus") as! String, temperatureF: data.value(forKey: "temperature") as! Float, lowTempF: data.value(forKey: "lowTemp") as! Float, highTempF: data.value(forKey: "highTemp") as! Float, weekDayF: data.value(forKey: "weekDay") as! String, sunRiseTimeF: data.value(forKey: "sunRiseTime") as! String, sunSetTimeF: data.value(forKey: "sunSetTime") as! String, degreeF: data.value(forKey: "degree") as! String, humidityF: data.value(forKey: "humidity") as! String, windF: data.value(forKey: "wind") as! String, feelsLikeF: data.value(forKey: "feelsLike") as! Float, pressureF: data.value(forKey: "pressure") as! String)
                
            }
            self.setCurrentWeatherData(data: temp)
        } catch
        {
            print("Current Weather data retrival failed")
        }
        
    }
    
    private func retriveDailyWeatherDataFromDb(){
        let dailyFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailyWeather")
        var tempArr = [DailyWeatherHelperClass]()
        do {
            let dailyResult = try context.fetch(dailyFetchRequest)
            for data in dailyResult as! [NSManagedObject]
            {
                var receivedImage = UIImage()
                if let imageData = data.value(forKey: "dailyWeatherIcon"){
                    receivedImage = UIImage(data: imageData as! Data)!
                }
                let temp = DailyWeatherHelperClass(weekday: data.value(forKey: "weekday") as! String, lowTemp: data.value(forKey: "lowTemp") as! Float, highTemp: data.value(forKey: "highTemp") as! Float,iconImage: receivedImage)
                temp.setNewValue(val: data.value(forKey: "consistancyIndex") as! Int)
                print("-------------- Daily ----------",(data.value(forKey: "consistancyIndex") as! Int16))
                print(data.value(forKey: "weekday") as! String)
                tempArr.append(temp)
            }
            self.setDailyWeatherData(data: tempArr)
        }catch {
            print("Daily Weather data retrival failed")
        }
    }
    
    private func retriveHourlyWeatherDataFromDb(){
        let hourlyFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HourlyWeather")
        var tempArr = [HourlyWeatherHelperClass]()
        do {
            let hourlyResult = try context.fetch(hourlyFetchRequest)
            for data in hourlyResult as! [NSManagedObject]
            {
                var receivedImage = UIImage()
                if let imageData = data.value(forKey: "hourWeatherIcon"){
                    receivedImage = UIImage(data: imageData as! Data)!
                }
                let temp = HourlyWeatherHelperClass(time: data.value(forKey: "time") as! String, temperature: data.value(forKey: "temperature") as! Float, iconImage: receivedImage)
                temp.setNewValue(val: data.value(forKey: "consistancyIndex") as! Int)
                tempArr.append(temp)
            }
            self.setHourlyWeatherData(data: tempArr)
        }catch {
            print("Hourly Weather data retrival failed")
        }
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}


