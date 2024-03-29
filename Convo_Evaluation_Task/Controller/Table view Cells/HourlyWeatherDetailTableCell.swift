//
//  HourlyWeatherDetailTableCell.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 23/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import UIKit

class HourlyWeatherDetailTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.hourlyWeatherCollectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherDetailCollectionCell", for: indexPath) as UICollectionViewCell
        print("Data Reloaded 4a")
                   if let customCell = cell as? HourlyWeatherDetailCollectionCell
                   {
                    customCell.tempLabel.text = String(hourlyWeatherData[indexPath.item].getTemp())+"\u{00B0}"
                    customCell.timeLabel.text = hourlyWeatherData[indexPath.item].getTime()
                    customCell.weatherIconImageView.image = hourlyWeatherData[indexPath.item].getIcon()
                    customCell.backgroundColor = #colorLiteral(red: 0.5762809327, green: 0.3830275923, blue: 0.5050187108, alpha: 0.78)
                   }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.hourlyWeatherCollectionView.frame.width/4 , height:  self.hourlyWeatherCollectionView.frame.height/6 )
       }


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    var hourlyWeatherData = [HourlyWeatherHelperClass]()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
