//
//  CalendarSection.swift
//  Geunal
//
//  Created by SolChan Ahn on 02/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import RxDataSources

struct CalendarSection {
    var year: Int
    var items: [Item]
}
extension CalendarSection: SectionModelType {
    typealias Item = CalendarCCellReactor
    
    init(original: CalendarSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct MonthSection {
    var items: [Item]
}
extension MonthSection: SectionModelType {
    typealias Item = DateCCellReactor
    
    init(original: MonthSection, items: [Item]) {
        self = original
        self.items = items
    }
}
