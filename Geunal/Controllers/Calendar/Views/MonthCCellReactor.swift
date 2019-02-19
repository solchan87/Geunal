//
//  MonthCCellReactor.swift
//  Geunal
//
//  Created by SolChan Ahn on 14/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

import ReactorKit

class MonthCCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        let year: Int
        let month: Int
    }
    
    let initialState : State
    
    init(year: Int, month: Int) {
        
        self.initialState = State(
            year: year,
            month: month
        )
        
        _ = self.state
    }
}
