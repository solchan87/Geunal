//
//  DateCCellReactor.swift
//  Geunal
//
//  Created by SolChan Ahn on 06/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

import ReactorKit

class DateCCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        let date: Date
        let isIncludedInMonth: Bool
        let issueCount: Int
    }
    
    let initialState : State
    
    init(date: Date, isIncludedInMonth: Bool) {
        
        self.initialState = State(
            date: date,
            isIncludedInMonth: isIncludedInMonth,
            issueCount: 0
        )
        
        _ = self.state
    }
}
