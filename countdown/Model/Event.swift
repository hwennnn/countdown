//
//  Event.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import CoreData

class Event{
    var id: String?
    var name: String
    var date: Date
    var created_at: Date
    var groups: [Group]
    
    init(_ name:String,_ date:Date,_ created_at:Date,_ groups:[Group]) {
        self.name = name
        self.date = date
        self.created_at = created_at
        self.groups = groups
    }
    
    init(_ id: String, _ name:String, _ date:Date, _ created_at:Date, _ groups:[Group]) {
        self.id = id
        self.name = name
        self.date = date
        self.created_at = created_at
        self.groups = groups
    }
}
