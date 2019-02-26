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
        case none
        case changeSearchYear(indexPath: IndexPath)
        case changeSearchMonth(indexPath: IndexPath)
    }
    
    enum Mutation {
        case setCalendar
        case setCurrentPage
        case changeSearchYear(indexPath: IndexPath)
        case changeSearchMonth(indexPath: IndexPath)
    }
    
    struct State {
        let currentYear: Int
        let currentMonth: Int
        
        var searchYear: Int
        var searchMonth: Int
        
        var indexPathOfCurrentTime: IndexPath = .init(item: 0, section: 0)
        
        var calendarSection: [CalendarSection] = []
        var yearSection: [YearSection] = []
        var monthSection: [MonthSection] = []
        
        var isLoaded: Bool = false
        
        init(currentYear: Int, currentMonth: Int) {
            self.currentYear = currentYear
            self.currentMonth = currentMonth
            self.searchYear = currentYear
            self.searchMonth = currentMonth
        }
    }
    
    let initialState : State
    
    let calendarService = CalendarService()
    
    init() {
        let currentDate = Date()
        
        self.initialState = State(currentYear: currentDate.getYear(), currentMonth: currentDate.getMonth())
        _ = self.state
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .start:
            let setCalendar = Observable<Mutation>.just(.setCalendar)
            let setCurrentPage = Observable<Mutation>.just(.setCurrentPage)
            return .concat([setCalendar, setCurrentPage])
        case .none:
            return .empty()
        case let .changeSearchYear(indexPath):
            return .just(Mutation.changeSearchYear(indexPath: indexPath))
        case let .changeSearchMonth(indexPath):
            return .just(Mutation.changeSearchMonth(indexPath: indexPath))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setCalendar:
            var calendarSection: [CalendarSection] = []
            var yearSection: [YearSection] = []
            var monthSection: [MonthSection] = []
            
            for year in calendarService.startYear...calendarService.endYear {
                var calendarItems: [CalendarCCellReactor] = []
                let yearItems: [YearCCellReactor] = [YearCCellReactor(year: year)]
                var monthItems: [MonthCCellReactor] = []
                
                for month in 1...12 {
                    calendarItems.append(CalendarCCellReactor(year: year, month: month))
                    monthItems.append(MonthCCellReactor(year: year,month: month))
                }
                calendarSection.append(CalendarSection(year: year, items: calendarItems))
                yearSection.append(YearSection(items: yearItems))
                monthSection.append(MonthSection(items: monthItems))
            }
            
            state.calendarSection = calendarSection
            state.yearSection = yearSection
            state.monthSection = monthSection
            
        case .setCurrentPage:
            let sectionOfYear: Int = initialState.currentYear - calendarService.startYear
            let itemOfMonth: Int = initialState.currentMonth - 1
            
            state.indexPathOfCurrentTime = IndexPath(item: itemOfMonth, section: sectionOfYear)
            
            state.isLoaded = true
        case let .changeSearchYear(indexPath):
            let searchYear = indexPath.section + calendarService.startYear
            
            state.searchYear = searchYear
        case let .changeSearchMonth(indexPath):
            let searchYear = indexPath.section + calendarService.startYear
            let searchMonth = indexPath.item + 1
            
            state.searchYear = searchYear
            state.searchMonth = searchMonth
        }
        return state
        
    }
}

