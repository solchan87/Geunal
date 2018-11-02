//
//  YearCollectionViewModel.swift
//  Geunal
//
//  Created by SolChan Ahn on 02/11/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

protocol YearCollectionViewModel {
    var calendarYearRange: [Int] { get }
    
    var year: Dynamic<Int> { get }
    
    func getIndexPath() -> IndexPath
}

class YearCollectionViewModelFrom: NSObject, YearCollectionViewModel {
    
    let currentTimeModel: CurrentTimeModel
    
    var calendarYearRange: [Int]
    
    var year: Dynamic<Int>
    
    init(currentTimeModel: CurrentTimeModel) {
        
        self.calendarYearRange = Array(CalendarYear.min ... CalendarYear.max)
        
        self.currentTimeModel = currentTimeModel
        
        self.year = Dynamic(currentTimeModel.currentYear)
    }
    
    
    func getIndexPath() -> IndexPath {
        let section = 0
        let row = self.year.value - CalendarYear.min
        let indexPath = IndexPath(row: row, section: section)
        
        return indexPath
    }
}
