//
//  NSCustomPersistentContainer.swift
//  countdown
//
//  Created by zachary on 31/1/21.
//

import UIKit
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.madcountdown")
        storeURL = storeURL?.appendingPathComponent("Countdown.sqlite")
        return storeURL!
    }

}
