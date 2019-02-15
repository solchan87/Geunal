//
//  IssueListViewReactor.swift
//  Geunal
//
//  Created by SolChan Ahn on 15/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import Foundation

import ReactorKit

class IssueListViewReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
    }
    
    let initialState : State
    
    init() {
        
        self.initialState = State()
        
        _ = self.state
    }
}
