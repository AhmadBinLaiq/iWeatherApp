//
//  ProgressHUD.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 30/05/2020. (code taken from stackoverflow, Author: Elliott Minns)
//  Edited by Ahmad Bin Laiq
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import UIKit

class ProgressHUD: UIVisualEffectView {

     var text: String? {
          didSet {
//            label.text = text
//            label.textColor = .white
          }
        }

    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
//        let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .prominent)
        let vibrancyView: UIVisualEffectView

        init(text: String) {
          self.text = text
          self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
          super.init(effect: blurEffect)
          self.setup()
        }

        required init?(coder aDecoder: NSCoder) {
          self.text = ""
          self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
          super.init(coder: aDecoder)
          self.setup()
        }

        func setup() {
          contentView.addSubview(vibrancyView)
          contentView.addSubview(activityIndictor)
//          contentView.addSubview(label)
          activityIndictor.startAnimating()
        }

        override func didMoveToSuperview()
        {
          super.didMoveToSuperview()

          if let superview = self.superview {

            let width = superview.frame.size.width / 9
            let height: CGFloat = 35.0
            self.frame = CGRect(x: superview.frame.size.width / 1.2 ,
                                y: superview.frame.height / 9 - height / 2,
                            width: width,
                            height: height)
            vibrancyView.frame = self.bounds

            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            activityIndictor.color = #colorLiteral(red: 0.3616552982, green: 0.2405221771, blue: 0.3134187302, alpha: 0.7786012414)

            layer.cornerRadius = 8.0
            layer.masksToBounds = true
//            label.text = text
//            label.textAlignment = NSTextAlignment.center
//            label.frame = CGRect(x: activityIndicatorSize + 5,
//                                 y: 0,
//                                 width: width - activityIndicatorSize - 15,
//                                 height: height)
//            label.textColor = UIColor.white
//            label.font = UIFont.boldSystemFont(ofSize: 15)
          }
        }

        func show() {
          self.isHidden = false
        }

        func hide() {
          self.isHidden = true
        }
      }
