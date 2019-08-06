//
//  Double+Utils.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 02/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation

extension Double {
    
    func temperatureToString() -> String {
        return String(format: "%.1f",self)
    }
    
    func coordinateToString() -> String {
        return String(format: "%.2f",self)
    }
}
