//
//  CalendarReactor.swift
//  Geunal
//
//  Created by SolChan Ahn on 01/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
    
class CalendarReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var calendarSection: [CalendarSection]
    }
    
    let initialState : State
    
    init() {
        var calendarSection: [CalendarSection] = []
        
        for year in 1970...2050 {
            var items: [CalendarCCellReactor] = []
            for month in 1...12 {
                items.append(CalendarCCellReactor(year: year, month: month))
            }
            calendarSection.append(CalendarSection(year: year, items: items))
        }
        
        self.initialState = State(calendarSection: calendarSection)
        _ = self.state
    }
}

