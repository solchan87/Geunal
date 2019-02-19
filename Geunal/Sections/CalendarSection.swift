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

struct YearSection {
    var items: [Item]
}
extension YearSection: SectionModelType {
    typealias Item = YearCCellReactor
    
    init(original: YearSection, items: [Item]) {
        self = original
        self.items = items
    }
}

struct MonthSection {
    var items: [Item]
}
extension MonthSection: SectionModelType {
    typealias Item = MonthCCellReactor
    
    init(original: MonthSection, items: [Item]) {
        self = original
        self.items = items
    }
}


struct DateSection {
    var items: [Item]
}
extension DateSection: SectionModelType {
    typealias Item = DateCCellReactor
    
    init(original: DateSection, items: [Item]) {
        self = original
        self.items = items
    }
}
