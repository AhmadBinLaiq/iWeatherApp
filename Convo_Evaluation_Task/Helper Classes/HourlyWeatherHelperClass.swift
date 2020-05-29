//
//  HourlyWeatherModel.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation
import UIKit

class HourlyWeatherHelperClass{
    private var time : String = ""
    private var temperature : Float = 0.0
    private var iconName : String = ""
    private var iconHourly : UIImage = UIImage()
    private var consistancyIndex : Int = 0
    
    init(time : String, temperature : Float,iconName : String = "" , iconImage: UIImage? = nil) {
//        print("Time is ", time)
        consistancyIndex += 1
        self.time = time
        self.temperature = temperature
        if iconImage != nil {
            self.iconHourly = iconImage!
        }
        if iconName != "" {
            self.iconName = iconName
            if self.iconName.contains("d"){ // issue in API, shows inverse icons
                self.iconName = self.iconName.replacingOccurrences(of: "d", with: "n")
            }
            else if self.iconName.contains("n")  {
                self.iconName = self.iconName.replacingOccurrences(of: "n", with: "d")
            }
            fetchIcon()
        }
        
    }
    
    func setNewValue(val: Int){
        consistancyIndex = val
    }
    
    
    func getConsistancyIndex() -> Int {
        return consistancyIndex
    }
    
    
    private func fetchIcon(){
        NetworDataFetcher.sharedNetworkInstance.fetchIconImage(iconName: self.iconName,size: 1){
            
            returnJSON in
            //             print("Final icon Name",self.iconName)
            self.iconHourly = (returnJSON)!
            //            self.swiftyJsonVar = JSON(returnJSON)
            
            
        }
    }
    
    func getTemp() -> Int {
        return Int(round(temperature))
    }
    
    func getTime() -> String{
        if time.count > 5
        {
            let fullNameArr : [String] = time.components(separatedBy: " ")
            let time1 =  fullNameArr[1].components(separatedBy: ":")
            time = time1[0]+":"+time1[1]
        }
        return time
    }
    
    func getIcon() -> UIImage{
        return iconHourly
    }
    
    func getHourlyWeather() -> (String,Float,String){
        return (getTime(),(round(temperature)),iconName)
    }
    
    init(){
        
    }
    
}
