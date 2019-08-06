//
//  CustomFiveDaysForecastTableviewCell.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 04/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit

class CustomFiveDaysForecastTableviewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for label in labels {
            label.textColor = .white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
