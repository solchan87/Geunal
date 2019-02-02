//
//  CalendarCCellReactor.swift
//  Geunal
//
//  Created by SolChan Ahn on 01/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

import ReactorKit

class CalendarCCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        let month: Int
    }
    
    let initialState : State
    
    init(month: Int) {
        
        self.initialState = State(month: month)
        
        _ = self.state
    }
}
