//
//  TrainTableViewCell.swift
//  VR_asema
//
//  Created by Matti Saarela on 08/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class TrainTableViewCell: UITableViewCell {

    @IBOutlet weak var category_label: UILabel!
    @IBOutlet weak var trailLabel: UILabel!
    @IBOutlet weak var trainNumberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
