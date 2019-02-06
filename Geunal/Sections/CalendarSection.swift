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

struct DatesSection {
    var items: [Item]
}
extension DatesSection: SectionModelType {
    typealias Item = CalendarCCellReactor
    
    init(original: DatesSection, items: [Item]) {
        self = original
        self.items = items
    }
}
