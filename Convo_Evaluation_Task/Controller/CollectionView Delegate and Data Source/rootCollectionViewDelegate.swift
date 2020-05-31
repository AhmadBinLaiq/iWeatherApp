//
//  rootCollectionViewDelegate.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 26/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import Foundation
import UIKit

class rootCollectionViewDelegate : NSObject, UICollectionViewDelegate
{
    var width = CGFloat(0.0)
    var height = CGFloat(0.0)
    init(viewWidth: CGFloat, viewHeight: CGFloat){
     width = viewWidth
        height = viewHeight
    }
    override init(){
        
    }
//    
//     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
////         let height = height
////         let width = width
//         // in case you you want the cell to be 40% of your controllers view
//         return CGSize(width: width, height: height)
//     }
  
    
}


//extension rootCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 414, height: 818)
//    }
//}
