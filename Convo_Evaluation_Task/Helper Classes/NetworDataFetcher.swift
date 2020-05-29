//
//  NetworkSuportClass.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworDataFetcher {
    
    static let sharedNetworkInstance = NetworDataFetcher()
    
    //    private init(){}
    
    func fetchIconImage(iconName: String,size: Int, completeonClosure: @escaping (UIImage?) -> ())
    {
        
        var strURL : String
        if size > 1 {
                 strURL = "http://openweathermap.org/img/wn/\(iconName)@\(size)x.png"
        }
        else {
                  strURL = "http://openweathermap.org/img/wn/\(iconName).png"
        }
      
        
        let url = URL(string: strURL)
        
//        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
//            DispatchQueue.main.async {
                completeonClosure(UIImage(data: data!))
//            }
//        }
    }
    
    
    func fetchWeatherData(lat: Float, lon: Float, completeonClosure: @escaping (JSON?,Bool) -> ())
        
    {
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=6a353f13b6d49a84fad1e63de6135d9a").responseJSON
            {
                (responseData) in
//                print(JSON(responseData.result.value!))
                completeonClosure(JSON(responseData.result.value! as AnyObject) as JSON,responseData.result.isSuccess) // big change
        }
        
    }
    
}



