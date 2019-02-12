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
    
    func getYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let result = Int(dateFormatter.string(from: self)) ?? 0
        
        return result
    }
    
    func getMonth() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        let result = Int(dateFormatter.string(from: self)) ?? 0
        
        return result
    }
    
    func getDate() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let result = Int(dateFormatter.string(from: self)) ?? 0
        
        return result
    }
    
    func getWeekDay() -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        
        return weekDay
    }
    
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        return dateFormatter.string(from: self)
    }
}
