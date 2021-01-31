//
//  AppGroup.swift
//  countdown
//
//  Created by shadow on 30/1/21.
//

import Foundation
import CoreData

public enum AppGroup: String {
    case facts = "group.com.coundown"

    public var containerURL: URL {
        switch self {
            case .facts:
                return FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier: self.rawValue)!
            }
    }
    
    public func startup(){
        let storeURL = AppGroup.facts.containerURL.appendingPathComponent("Data.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)

        let container = NSPersistentContainer(name: "World")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores {_,_ in 
            
        }
    }
    
    
}
