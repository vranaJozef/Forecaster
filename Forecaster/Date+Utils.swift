//
//  DateFormatter.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

extension Date {
    
    private func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter
    }
    
    func hhMMSSFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        return dateFormatter.string(from: self)        
    }
    
    func ddmmYYYYFormatter() -> String {
        let dateFormatter = self.dateFormatter()
        let formattedString = dateFormatter.string(from: self)
        return formattedString
    }
    
    func addOneDay() -> String? {
        let dateFormatter = self.dateFormatter()
        guard let adjustedDate = Calendar.current.date(byAdding: .day, value: 1, to: self) else { return nil }
        let convertedDate = dateFormatter.string(from: adjustedDate)
        return convertedDate
    }       
}
