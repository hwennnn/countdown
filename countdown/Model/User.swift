//
//  User.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation

class User{
    var name: String
    var email: String
    var events: [Event]
    
    init(_ Name:String, _ Email:String, _ Events:[Event]) {
        name = Name
        email = Email
        events = Events
    }
    
}
