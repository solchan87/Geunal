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
        let currentYear: Int
        let currentMonth: Int
        
        var indexPathOfCurrentTime: IndexPath = .init(item: 0, section: 0)
        
        var calendarSection: [CalendarSection] = []
        let yearList: [Int]
        let monthList: [Int]
        
        var isLoaded: Bool = false
        
        init(currentYear: Int, currentMonth: Int, yearList: [Int], monthList: [Int]) {
            self.currentYear = currentYear
            self.currentMonth = currentMonth
            self.yearList = yearList
            self.monthList = monthList
        }
    }
    
    let initialState : State
    
    let calendarService = CalendarService()
    
    init() {
        let currentDate = Date()
        let yearList: [Int] = Array(calendarService.startYear...calendarService.endYear)
        let monthList: [Int] = Array(1...12000)
        
        self.initialState = State(currentYear: currentDate.getYear(), currentMonth: currentDate.getMonth(), yearList: yearList, monthList: monthList)
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
            let sectionOfYear: Int = initialState.currentYear - calendarService.startYear
            let itemOfMonth: Int = initialState.currentMonth - 1
            
            print(sectionOfYear, itemOfMonth)
            
            state.indexPathOfCurrentTime = IndexPath(item: itemOfMonth, section: sectionOfYear)
            
            state.isLoaded = true
        }
        return state
        
    }
}

