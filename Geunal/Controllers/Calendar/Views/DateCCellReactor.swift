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
        let issueCount: Int
    }
    
    let initialState : State
    
    init(date: Date) {
        
        self.initialState = State(
            date: date,
            issueCount: 0
        )
        
        _ = self.state
    }
}
