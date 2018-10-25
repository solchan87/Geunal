//
//  RealmService.swift
//  Geunal
//
//  Created by SolChan Ahn on 22/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation
import RealmSwift

class DayMessage: Object {
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var createDate = Date()
    @objc dynamic var timeNum = 0
    @objc dynamic var year = 0
    @objc dynamic var month = 0
    @objc dynamic var date = 0
    @objc dynamic var lastOeder = 0
    @objc dynamic var state = ""
    let messages = List<Message>()
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

class Message: Object {
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var order = 0
    @objc dynamic var createDate = Date()
    @objc dynamic var state = ""
    @objc dynamic var text = ""
    let messages = List<SelectTag>()

    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

class SelectTag: Object {
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var tagId = ""
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
