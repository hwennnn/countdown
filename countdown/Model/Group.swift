//
//  Group.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import CoreData

class Group{
    var id: String?
    var name: String?
    
    init(){}
    
    init(_ name:String) {
        self.name = name
    }
    
    init(_ id:String, _ name:String) {
        self.id = id
        self.name = name
    }
}
