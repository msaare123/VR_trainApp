//
//  RouteTableViewCell.swift
//  VR_asema
//
//  Created by Matti Saarela on 09/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var station_label: UILabel!
 
    @IBOutlet weak var additional_label: UILabel!

    @IBOutlet weak var timetext_label: UILabel!
    
    @IBOutlet weak var time_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
