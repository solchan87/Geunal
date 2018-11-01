//
//  CurrentTimeModel.swift
//  Geunal
//
//  Created by SolChan Ahn on 31/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

enum StringOf {
    static let sunday = "일요일"
    static let monday = "월요일"
    static let tuesday = "화요일"
    static let wednesday = "수요일"
    static let thursday = "목요일"
    static let friday = "금요일"
    static let saturday = "토요일"
}

class CurrentTimeModel: NSObject {
    
    var currentYear: Int
    var currentMonth: Int
    var currentDate: Int
    var currentDay: Int
    
    let formatter = DateFormatter()
    let calendar = Calendar(identifier: .gregorian)
    
    override init() {
        
        let date = Date()
        formatter.dateFormat = "yyyy.MM.ss"
        let result = formatter.string(from: date)
        
        let time = result.components(separatedBy: ".")
        
        self.currentYear = Int(time[0]) ?? 0
        self.currentMonth = Int(time[1]) ?? 0
        self.currentDate = Int(time[2]) ?? 0
        self.currentDay = calendar.component(.weekday, from: date)
    }
    
    func getCurrentTime() {
        
        let date = Date()
        formatter.dateFormat = "yyyy.MM.ss"
        let result = formatter.string(from: date)
        
        let time = result.components(separatedBy: ".")
        
        self.currentYear = Int(time[0]) ?? 0
        self.currentMonth = Int(time[1]) ?? 0
        self.currentDate = Int(time[2]) ?? 0
        self.currentDay = calendar.component(.weekday, from: date)
        
    }

}
