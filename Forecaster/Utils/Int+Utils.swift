//
//  Int+Utils.swift
//  Forecaster
//
//  Created by Vrana, Jozef on 04/08/2019.
//  Copyright © 2019 Vrana, Jozef. All rights reserved.
//

import Foundation

extension Int {
    
    func toString() -> String {
        return String(self)
    }
    
    func toUTC() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.string(from: Date(timeIntervalSince1970: Double(self)))
        return date
    }
    
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let date = Date(timeIntervalSince1970: Double(self))
        return dateFormatter.string(from: date)
    }
    
}
