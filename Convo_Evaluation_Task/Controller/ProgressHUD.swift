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
    let blurEffect = UIBlurEffect(style: .dark)
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
          activityIndictor.startAnimating()
        }

        override func didMoveToSuperview()
        {
          super.didMoveToSuperview()

          if let superview = self.superview {

            let width : CGFloat = 35
            let height: CGFloat = 35
            self.frame = CGRect(x: superview.frame.size.width / 1.22 ,
                                y: superview.frame.height / 9 - height / 3.7,
                            width: width,
                            height: height)
            vibrancyView.frame = self.bounds

            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 0,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            activityIndictor.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            layer.cornerRadius = 8.0
            layer.masksToBounds = true

          }
        }

        func show() {
          self.isHidden = false
        }

        func hide() {
          self.isHidden = true
        }
      }
