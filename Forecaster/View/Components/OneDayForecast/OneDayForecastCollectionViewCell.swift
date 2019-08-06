//
//  OneDayForecastCollectionViewCell.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 04/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import UIKit

class OneDayForecastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var temperature: UILabel?
    @IBOutlet var labels: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for label in labels {
            label.textColor = .white
        }
    }

}
