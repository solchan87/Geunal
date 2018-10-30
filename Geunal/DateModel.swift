//
//  DateModel.swift
//  Geunal
//
//  Created by SolChan Ahn on 29/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

class DateModel: NSObject {
    var date: Int
    var ofWeek: Int
    var isToday: Bool
    
    init(date: Int, ofWeek: Int, isToday: Bool){
        self.date = date
        self.ofWeek = ofWeek
        self.isToday = isToday
    }
}
