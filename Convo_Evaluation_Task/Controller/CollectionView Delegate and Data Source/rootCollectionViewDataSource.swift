//
//  rootCollectionViewDataSource.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 26/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation
import UIKit

class rootCollectionViewDataSource: NSObject, UICollectionViewDataSource {
     
    var weatherModel : WeatherModel
    
    init(weatherModelT : WeatherModel) {
        self.weatherModel = weatherModelT
    }
    
    override init(){
        weatherModel = WeatherModel()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
        return 1
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RootWeatherCollectionViewCell", for: indexPath) as UICollectionViewCell

            if let customCell = cell as? RootWeatherCollectionViewCell
            {
                print("Data Reloaded 7")
                customCell.weatherData = weatherModel
                customCell.subRootTableView.backgroundColor = #colorLiteral(red: 0.3616552982, green: 0.2405221771, blue: 0.3134187302, alpha: 0.7786012414)
                customCell.subRootTableView.separatorStyle = .singleLine
                customCell.subRootTableView.separatorColor = .white
                customCell.subRootTableView.reloadData()
                
            }
            return cell
        }
    
    
    
    
}
