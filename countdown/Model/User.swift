//
//  User.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import CoreData

class User{
    var id: String?
    var name: String
    var email: String
    var events: [Event]
    
    init(_ id:String, _ name:String, _ email:String, _ events:[Event]) {
        self.id = id
        self.name = name
        self.email = email
        self.events = events
    }
    
    init(_ name:String, _ email:String, _ events:[Event]) {
        self.name = name
        self.email = email
        self.events = events
    }

}
