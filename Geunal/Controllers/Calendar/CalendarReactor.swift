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
    
    enum Action {
        case start
    }
    
    enum Mutation {
        case setCalendar
        case setCurrentPage
    }
    
    struct State {
        var calendarSection: [CalendarSection] = []
        
        var isLoaded: Bool = false
    }
    
    let initialState : State
    
    let calendarService = CalendarService()
    
    init() {
        self.initialState = State()
        _ = self.state
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .start:
            let setCalendar = Observable<Mutation>.just(.setCalendar)
            let setCurrentPage = Observable<Mutation>.just(.setCurrentPage)
            return .concat([setCalendar, setCurrentPage])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setCalendar:
            var calendarSection: [CalendarSection] = []
            
            for year in calendarService.startYear...calendarService.endYear {
                var items: [CalendarCCellReactor] = []
                for month in 1...12 {
                    items.append(CalendarCCellReactor(year: year, month: month))
                }
                calendarSection.append(CalendarSection(year: year, items: items))
            }
            
            state.calendarSection = calendarSection
        case .setCurrentPage:
            state.isLoaded = true
        }
        return state
        
    }
}

