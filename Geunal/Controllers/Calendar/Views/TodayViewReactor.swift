//
//  TodayViewReactor.swift
//  Geunal
//
//  Created by SolChan Ahn on 15/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

import ReactorKit

class TodayViewReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        let currentDate = Date()
    }
    
    let initialState : State
    
    init() {
        
        self.initialState = State()
        
        _ = self.state
    }
}
