//
//  CalendarCCellReactor.swift
//  Geunal
//
//  Created by SolChan Ahn on 01/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

class CalendarCCellReactor: Reactor {
    
    enum Action {
        case getDateList()
    }
    
    enum Mutation {
        case setDatesSection()
    }
    
    struct State {
        let year: Int
        let month: Int
        
        var monthSection: [DateSection] = []
        
        init(year: Int, month: Int) {
            self.year = year
            self.month = month
        }
    }
    
    let initialState : State
    
    let calendarService = CalendarService()
    
    init(year: Int, month: Int) {
        
        self.initialState = State(
            year: year,
            month: month
        )
        _ = self.state
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getDateList :
            return .just(Mutation.setDatesSection())
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setDatesSection:
            let dateItems: [DateCCellReactor] = calendarService.getDateDatas(
                year: initialState.year, month: initialState.month
            )
            
            state.monthSection = [DateSection(items: dateItems)]
        }
        return state
        
    }
}
