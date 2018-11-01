//
//  MainCollectionViewModel.swift
//  Geunal
//
//  Created by SolChan Ahn on 29/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

protocol MainViewModel {
    
    var currentYear: Dynamic<Int> { get }
    var currentMonth: Dynamic<Int> { get }
    var currentDate: Dynamic<Int> { get }
    var currentDayToString: Dynamic<String> { get }
    
    func getCurrentDate()
    
}

class MainViewModelFromCurrentTime: NSObject, MainViewModel {
    
    let currentTime: CurrentTimeModel
    
    let currentYear: Dynamic<Int>
    let currentMonth: Dynamic<Int>
    let currentDate: Dynamic<Int>
    let currentDayToString: Dynamic<String>
    
    let formatter = DateFormatter()
    let myCalendar = Calendar(identifier: .gregorian)
    
    init(withCurrentTime currentTime:  CurrentTimeModel) {
        
        self.currentTime = currentTime
        
        self.currentYear = Dynamic(currentTime.currentYear)
        self.currentMonth = Dynamic(currentTime.currentMonth)
        self.currentDate = Dynamic(currentTime.currentDate)
        self.currentDayToString = Dynamic(MainViewModelFromCurrentTime.dayToString(week: currentTime.currentDay))
        
    }
    
    func getCurrentDate() {
        self.currentTime.getCurrentTime()
        
        self.currentYear.value = currentTime.currentYear
        self.currentMonth.value = currentTime.currentMonth
        self.currentDate.value = currentTime.currentDate
        self.currentDayToString.value = MainViewModelFromCurrentTime.dayToString(week: currentTime.currentDay)
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
