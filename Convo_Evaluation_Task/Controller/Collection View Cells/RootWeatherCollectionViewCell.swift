//
//  RootWeatherCollectionViewCell.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 24/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import UIKit

class RootWeatherCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate  {
    

    @IBOutlet weak var subRootTableView: UITableView!
    
    var currentWeatherDetails = [[String]]()
    var weatherData = WeatherModel()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell
        currentWeatherDetails = [
            ["Sun Rise", weatherData.getCurrentWeatherData().getSunRiseTime()],
            ["Sun Set",weatherData.getCurrentWeatherData().getSunSetTime()],
            ["Wind",weatherData.getCurrentWeatherData().getWind() + " mph"],
            ["Degree",weatherData.getCurrentWeatherData().getDegree() + "\u{00B0}"],
            ["Humidity",weatherData.getCurrentWeatherData().getHumidity()+" %"],
            ["Pressure",(weatherData.getCurrentWeatherData().getPressure()+" pha")]
        ]
        if indexPath.item == 0 {
            cell = self.subRootTableView.dequeueReusableCell(withIdentifier: "CurrentWeatherDetailTableCell", for: indexPath) as UITableViewCell
            if let customCell = cell as? CurrentWeatherDetailTableCell
            {
                // change here.. .. add reload data lines
                print("Data Reloaded 3")
                customCell.currentWeatherData = weatherData.getCurrentWeatherData()
                customCell.backgroundColor = #colorLiteral(red: 0.3616552982, green: 0.2405221771, blue: 0.3134187302, alpha: 0.7786012414)
//                tableView.headerView(forSection: 0)?.isHidden = true
            }
        }
        else if indexPath.item == 1  {
            cell = self.subRootTableView.dequeueReusableCell(withIdentifier: "HourlyWeatherDetailTableCell", for: indexPath) as UITableViewCell
            if let customCell = cell as? HourlyWeatherDetailTableCell
            {
                
                print("Data Reloaded 4")
                customCell.hourlyWeatherData = weatherData.getHourlyWeatherData()
//                customCell.hourlyWeatherCollectionView.reloadData()
                customCell.backgroundColor = #colorLiteral(red: 0.3616552982, green: 0.2405221771, blue: 0.3134187302, alpha: 0.7786012414)
                customCell.hourlyWeatherCollectionView.reloadData() // chane 2
                
            }
        }
        else if indexPath.item == 2 {
            cell = self.subRootTableView.dequeueReusableCell(withIdentifier: "CityDailyWeatherTableCell", for: indexPath) as UITableViewCell
            if let customCell = cell as? CityDailyWeatherTableCell
            {
                print("Data Reloaded 5")
//                customCell.CityDailyWea
                customCell.dailyWeatherData = weatherData.getDailyWeatherData()
                customCell.backgroundColor = #colorLiteral(red: 0.5762809327, green: 0.3830275923, blue: 0.5050187108, alpha: 0.7786012414)
                customCell.dailyWeatherTableView.reloadData() //change 1
                
            }
        }
        else {
            
            cell = self.subRootTableView.dequeueReusableCell(withIdentifier: "simpleCurrentDetailTableCell", for: indexPath) as UITableViewCell
            if let customCell = cell as? simpleCurrentDetailTableCell
            {
                print("Data Reloaded 6")
                let count  = indexPath.item - 3
                customCell.title1st.text = currentWeatherDetails[indexPath.item-3+count][0] // 0,0
                customCell.description1st.text = currentWeatherDetails[indexPath.item-3+count][1] // 0,1
                customCell.title2nd.text = currentWeatherDetails[indexPath.item-2+count][0] // 1,0
                customCell.description2nd.text = currentWeatherDetails[indexPath.item-2+count][1] // 1,1
                customCell.backgroundColor = #colorLiteral(red: 0.3616552982, green: 0.2405221771, blue: 0.3134187302, alpha: 0.7786012414)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return (self.subRootTableView.frame.height * 45)/100
        }
        else if indexPath.item == 1 {
            return (self.subRootTableView.frame.height * 15)/100
        }
        else if indexPath.item == 2 {
            return (self.subRootTableView.frame.height * 30)/100
        }
        else{
            return (self.subRootTableView.frame.height * 10)/100
        }
        //        return (self.subRootTableView.frame.height * 45)/100
    }
    
    
    
    
    
    
}
