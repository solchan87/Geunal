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
        let date: Int
        let isDateIncludedInMonth: Bool
        let issueCount: Int
    }
    
    let initialState : State
    
    init(year: Int, month: Int, date: Int) {
        
        self.initialState = State(month: month)
        
        _ = self.state
    }
}
