//
//  MonthCollectionViewModel.swift
//  Geunal
//
//  Created by SolChan Ahn on 04/11/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

protocol MonthCollectionViewModel {
    
    var month: Dynamic<Int> { get }
    
    var cellCount: Int { get }
    
    func getCurrentIndexPath() -> IndexPath
}

class MonthCollectionViewModelFrom: NSObject, MonthCollectionViewModel {
    
    let currentTimeModel: CurrentTimeModel
    
    var month: Dynamic<Int>
    
    let cellCount = 1000000
    
    init(currentTimeModel: CurrentTimeModel) {
        
        self.currentTimeModel = currentTimeModel
        
        self.month = Dynamic(currentTimeModel.currentMonth)
    }
    
    
    func getCurrentIndexPath() -> IndexPath {
        let section = 0
        let row = self.month.value - CalendarYear.min
        let indexPath = IndexPath(row: row, section: section)
        
        return indexPath
    }
}
