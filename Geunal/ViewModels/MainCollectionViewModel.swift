//
//  MainCollectionViewModel.swift
//  Geunal
//
//  Created by SolChan Ahn on 01/11/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

protocol MainCollectionViewModel {
    
    var calendarYearLimit: [Int] { get }
    
    var currentYear: Dynamic<Int> { get }
    var currentMonth: Dynamic<Int> { get }
}

class MainCollectionViewModelFromCurrentTime:NSObject, MainCollectionViewModel {
    
    let currentTime: CurrentTimeModel
    
    let calendarYearLimit: [Int]
    
    let currentYear: Dynamic<Int>
    let currentMonth: Dynamic<Int>
    
    init(withCurrentTime currentTime: CurrentTimeModel) {
        
        self.calendarYearLimit = Array(CalendarYear.min ... CalendarYear.max)
        
        self.currentYear = Dynamic(currentTime.currentYear)
        self.currentMonth = Dynamic(currentTime.currentMonth)
    }
    
    func getIndexPath(forYear year: Int, month: Int) -> IndexPath {
        var indexPath = IndexPath()
        
        indexPath.section = year - CalendarYear.min
        indexPath.row = month - 1
        
        return indexPath
    }
    
}
