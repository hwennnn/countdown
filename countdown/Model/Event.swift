//
//  Event.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import CoreData

class Event{
    var id: String
    var name: String
    var emoji: String
    var includedTime: Bool
    var date: Date
    var time: Date
    var created_at: Date
    var reminders: String
    var colour: Int
    var progress: Float
    
    init(_ id: String, _ name:String, _ emoji:String, _ includedTime:Bool, _ date:Date, _ time:Date, _ created_at:Date, _ reminders:String, _ colour:Int, _ progress:Float) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.includedTime = includedTime
        self.date = date
        self.time = time
        self.created_at = created_at
        self.reminders = reminders
        self.colour = colour
        self.progress = progress
    }
}
