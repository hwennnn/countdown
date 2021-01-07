//
//  Event.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation

class Event{
    // to be added: id
    var name: String
    var date: Date
    var created_at: Date
    var groups: [Group]
    
    init(_ Name:String, _ Date:Date, _ Created_at:Date, _ Groups:[Group]) {
        name = Name
        date = Date
        created_at = Created_at
        groups = Groups
    }
}
