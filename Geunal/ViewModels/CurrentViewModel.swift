//
//  MainCollectionViewModel.swift
//  Geunal
//
//  Created by SolChan Ahn on 29/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

protocol CurrentViewModel {
    
    var currentYear: Dynamic<Int> { get }
    var currentMonth: Dynamic<Int> { get }
    var currentDate: Dynamic<Int> { get }
    var currentDay: Dynamic<String> { get }
    
    func getCurrentTime()
}

class CurrentViewModelFromMain: NSObject, CurrentViewModel {
    
    let currentYear: Dynamic<Int>
    let currentMonth: Dynamic<Int>
    let currentDate: Dynamic<Int>
    let currentDay: Dynamic<String>
    
    let tDate = Date()
    let formatter = DateFormatter()
    let myCalendar = Calendar(identifier: .gregorian)
    
    override init() {
        
        formatter.dateFormat = "yyyy.MM.dd"
        
        let result = formatter.string(from: tDate)
        
        let time = result.components(separatedBy: ".")
        
        self.currentYear = Dynamic(Int(time[0]) ?? 0)
        self.currentMonth = Dynamic(Int(time[1]) ?? 0)
        self.currentDate = Dynamic(Int(time[2]) ?? 0)
        
        self.currentDay = Dynamic(CurrentViewModelFromMain.dayToString(week: myCalendar.component(.weekday, from: tDate)))
    }
    
    func getCurrentTime() {
        formatter.dateFormat = "yyyy.MM.dd"
        
        let result = formatter.string(from: tDate)
        
        let time = result.components(separatedBy: ".")
        
        self.currentYear.value = Int(time[0]) ?? 0
        self.currentMonth.value = Int(time[1]) ?? 0
        self.currentDate.value = Int(time[2]) ?? 0
        
        self.currentDay.value = CurrentViewModelFromMain.dayToString(week: myCalendar.component(.weekday, from: tDate)
)
    }
    
    fileprivate static func dayToString(week: Int) -> String {
        switch week {
        case 1:
            return StringOf.sunday
        case 2:
            return StringOf.monday
        case 3:
            return StringOf.tuesday
        case 4:
            return StringOf.wednesday
        case 5:
            return StringOf.thursday
        case 6:
            return StringOf.friday
        case 7:
            return StringOf.saturday
        default:
            return ""
        }
    }
    
}
