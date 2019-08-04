//
//  String+Utils.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 03/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation

extension String {
    
    func celcius() -> String {
        return self + "℃"
    }
    
    func windSpeed() -> String {
        return self + "m/s"
    }
    
    func percent() -> String {
        return self + "%"
    }    
}
