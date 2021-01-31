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
    var progress: Float
    var includedTime: Bool
    var reminderPicked: Int
    var colour: String?
    var icon: String?
    
    init(_ name:String,_ date:Date,_ created_at:Date, progress:Float,  _ includedTime:Bool, _ reminderPicked:Int) {
        self.name = name
        self.date = date
        self.created_at = created_at
        self.progress = progress
        self.includedTime = includedTime
        self.reminderPicked = reminderPicked
    }
    
    init(_ id: String, _ name:String, _ date:Date, _ created_at:Date, _ progress:Float,  _ includedTime:Bool, _ reminderPicked:Int) {
        self.id = id
        self.name = name
        self.date = date
        self.created_at = created_at
        self.progress = progress
        self.includedTime = includedTime
        self.reminderPicked = reminderPicked
    }
}
