//
//  StationTableViewCell.swift
//  VR_asema
//
//  Created by Matti Saarela on 07/02/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var station_label: UILabel! //Asemataulukon solu
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
