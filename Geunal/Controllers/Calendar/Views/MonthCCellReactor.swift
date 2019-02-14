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
        let month: Int
    }
    
    let initialState : State
    
    init(month: Int) {
        
        self.initialState = State(
            month: month
        )
        
        _ = self.state
    }
}
