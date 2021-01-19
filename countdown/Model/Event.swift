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
    var group: Group?
    var progress: Int32
    var includedTime: Bool
    
    init(_ name:String,_ date:Date,_ created_at:Date,_ group:Group, progress:Int32,  _ includedTime:Bool) {
        self.name = name
        self.date = date
        self.created_at = created_at
        self.group = group
        self.progress = progress
        self.includedTime = includedTime
    }
    
    init(_ id: String, _ name:String, _ date:Date, _ created_at:Date, _ progress:Int32,  _ includedTime:Bool) {
        self.id = id
        self.name = name
        self.date = date
        self.created_at = created_at
        self.progress = progress
        self.includedTime = includedTime
    }
    
    init(_ id: String, _ name:String, _ date:Date, _ created_at:Date, _ group:Group, _ progress:Int32, _ includedTime:Bool) {
        self.id = id
        self.name = name
        self.date = date
        self.created_at = created_at
        self.group = group
        self.progress = progress
        self.includedTime = includedTime
    }
}
