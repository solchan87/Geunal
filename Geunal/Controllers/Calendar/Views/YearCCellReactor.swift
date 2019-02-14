//
//  YearCCellReactor.swift
//  Geunal
//
//  Created by SolChan Ahn on 14/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

import ReactorKit

class YearCCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        let year: Int
    }
    
    let initialState : State
    
    init(year: Int) {
        
        self.initialState = State(
            year: year
        )
        
        _ = self.state
    }
}
