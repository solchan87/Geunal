//
//  CalendarModel.swift
//  Geunal
//
//  Created by SolChan Ahn on 28/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

enum CalendarYear {
    static let min = 1930
    static let max = 2050
}

enum MonthNotifications {
    static let MonthDidChangeNotification = "MonthDidChangeNotification"
}

class MonthModel: NSObject {
    let year: Int
    let month: Int
    let date: [DateModel]
    
    init(year: Int, month: Int) {
        self.year = year
        self.month = month
        self.date = []
    }
    
    // MARK: private
    
    // 각 월의 마지막 일을 반환
    fileprivate func getLastDate(year: Int, month: Int) -> Int{
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) ? 29 : 28
        default:
            return 0
        }
    }
    
    
    // 각 월의 첫 일의 요일을 반환
    // 일요일: 1, 토요일: 7
    fileprivate func getDayOfWeek(year: Int, month: Int) -> Int {
        let timeToString: String = String((year * 10000) + (month * 100) + 1)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let firstDate = formatter.date(from: timeToString)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: firstDate!)
        
        return weekDay
    }
}
