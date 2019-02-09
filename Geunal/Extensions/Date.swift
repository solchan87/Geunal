//
//  Date.swift
//  Geunal
//
//  Created by SolChan Ahn on 09/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func lastEndOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 0, day: -1), to: self.startOfMonth())!
    }
    
    func lastEndDate() -> Int? {
        return Calendar.current.dateComponents([.day], from: self.lastEndOfMonth()).day
    }
    
    func endDate() -> Int? {
        return Calendar.current.dateComponents([.day], from: self.endOfMonth()).day
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self.startOfMonth()).weekday
    }
    
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        
        return dateFormatter.string(from: self)
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        return dateFormatter.string(from: self)
    }
    
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: self)
    }
}
