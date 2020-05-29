//
//  simpleCurrentDetailTableCell.swift
//  Convo_Evaluation_Task
//
//  Created by Ahmad Bin Laiq on 26/05/2020.
//  Copyright © 2020 Ahmad Bin Laiq. All rights reserved.
//

import UIKit

class simpleCurrentDetailTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var title2nd: UILabel!
    @IBOutlet weak var title1st: UILabel!
    @IBOutlet weak var description1st: UILabel!
    @IBOutlet weak var description2nd: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
