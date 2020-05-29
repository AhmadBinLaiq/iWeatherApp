//
//  currentWeatherDetailTableCell.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 23/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import UIKit

class CurrentWeatherDetailTableCell: UITableViewCell {

    
    var currentWeatherData = CurrentWeatherHelperClass()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var min_maxTempLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var tempDisplayLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        cityLabel.sizeToFit()
        lastUpdated.sizeToFit()
        currentDay.sizeToFit()
        min_maxTempLabel.sizeToFit()
        weatherConditionLabel.sizeToFit()
        tempDisplayLabel.sizeToFit()
        feelsLike.sizeToFit()
        print("Last updatded 2: ",currentWeatherData.getCurrentWeatherData().getLastUpdated())
        print("Data Reloaded 1")
        lastUpdated.text = "Updated: \(currentWeatherData.getCurrentWeatherData().getLastUpdated()) mins ago"
        currentDay.text = currentWeatherData.getWeekDay()+",Today"
        cityLabel.text = currentWeatherData.getCity()
        min_maxTempLabel.text = "\(currentWeatherData.getLowTemp())\u{00B0} / \(currentWeatherData.getHighTemp())\u{00B0}"
        weatherConditionLabel.text = currentWeatherData.getWeatherStatus()
        tempDisplayLabel.text = "\(currentWeatherData.getTemperature())\u{00B0}"
        feelsLike.text = "Feels Like: " + String(currentWeatherData.getFeelsLike()) + "\u{00B0}"
//        
        // Configure the view for the selected state
    }

}
