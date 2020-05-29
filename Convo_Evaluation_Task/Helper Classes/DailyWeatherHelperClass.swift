//
//  DailyWeatherModel.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DailyWeatherHelperClass {
    private var weekDay : String = ""
    private var lowTemp : Float = 0.0
    private var highTemp : Float = 0.0
    private var iconName : String = ""
    private var iconDaily : UIImage = UIImage()
    //    private var swiftyJsonVar =  JSON()
    private var weekDays = ["","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    private var consistancyIndex = 0
    
    init(weekday : String, lowTemp : Float,highTemp : Float,iconName : String = "" , iconImage: UIImage? = nil) {
        //        let fullNameArr : [String] = weekday.components(separatedBy: " ")
        
        self.weekDay = weekday
        self.lowTemp = (lowTemp)
        self.highTemp = (highTemp)
//         print("Icon 1",iconName)
        self.iconName = iconName.replacingOccurrences(of: "n", with: "d")
        if iconImage != nil {
            self.iconDaily = iconImage!
        }
        if iconName != "" {
            fetchIcon()
        }
//        print("Icon 2",self.iconName)
        
    }
    
    func getConsistancyIndex() -> Int {
        return consistancyIndex
    }
    
    func setNewValue(val: Int){
        
        consistancyIndex = val
//        print("inserted values :: ",consistancyIndex)
    }
    
    
    private func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    func getLowTemp() -> Int {
        return Int((lowTemp))
    }
    
    func getHighTemp() -> Int {
        return Int((highTemp))
    }
    
    func getWeekDay() -> String{
        if weekDay != "" && !weekDay.contains("day"){
            
            let fullNameArr : [String] = weekDay.components(separatedBy: " ")
            self.weekDay = weekDays[getDayOfWeek(fullNameArr[0])!]
//            print(getDayOfWeek(fullNameArr[0])!)
        }
        return weekDay
    }
    
    func getIcon() -> UIImage{
        return iconDaily
    }
    
    private func fetchIcon(){
        NetworDataFetcher.sharedNetworkInstance.fetchIconImage(iconName: iconName,size: 4){
            returnJSON in
//            print("Final icon Name",self.iconName)
            self.iconDaily = (returnJSON)!
            //            self.swiftyJsonVar = JSON(returnJSON)
        }
    }
    
    func changeWeekDate(){
        
        let st = weekDay
        
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFmt.date(from: st) {
            
            dateFmt.dateFormat = "dd/MM/yyyy HH:mm a"
            let finalDate = dateFmt.string(from: date)
//            print("+++++++++++++++++++++")
//            print(finalDate)
//            print("+++++++++++++++++++++")
        }
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "hh:mm:ss"
        //        var date = dateFormatter.date(from: "00:00:00")
        //        var str_from_date = dateFormatter.string(from: date!)
        //
        //        print("+++++++++++++++++++++")
        //        print(finalDate)
        //        print("+++++++++++++++++++++")
    }
    
    func getDailyData() -> (String,Int,Int,String) {
        return (getWeekDay(),getLowTemp() ,getHighTemp(),iconName)
    }
    init(){
        
    }
    
    
    
}
