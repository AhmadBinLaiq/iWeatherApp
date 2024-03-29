//
//  CityDailyWeatherCell.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 23/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import UIKit

class CityDailyWeatherTableCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate   {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dailyWeatherData.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.dailyWeatherTableView.dequeueReusableCell(withIdentifier: "DailyWeatherTableCell", for: indexPath) as UITableViewCell
    if let customCell = cell as? DailyWeatherTableCell
    {
        print("data reloaded 5a ")
        customCell.dayDateAndMonthLabel.text = dailyWeatherData[indexPath.item].getWeekDay()
        customCell.min_MaxTempLabel.text = "\(dailyWeatherData[indexPath.item].getLowTemp())\u{00B0}/ \(dailyWeatherData[indexPath.item].getHighTemp())\u{00B0}"
        customCell.weatherImageView.image = dailyWeatherData[indexPath.item].getIcon()
         customCell.backgroundColor = #colorLiteral(red: 0.3616552982, green: 0.2405221771, blue: 0.3134187302, alpha: 0.7786012414)
    }
    return cell
}
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 45
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    @IBOutlet weak var dailyWeatherTableView: UITableView!
    var dailyWeatherData = [DailyWeatherHelperClass]()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
