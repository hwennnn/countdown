//
//  CoredataUtils.swift
//  countdown
//
//  Created by shadow on 2/2/21.
//

import Foundation
import CoreData
import WidgetKit

class CoredataUtils{
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSCustomPersistentContainer(name: "countdown")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchdata() -> ([Event]){
        let managedContext = persistentContainer.viewContext
        var eventList:[Event] = []
        var events:[CDEvent] = []
        var completed:[Event] = []
        var incomplete:[Event] = []
        
        let utils = Utility()
        let fetchRequest = NSFetchRequest<CDEvent>(entityName: "CDEvent")
        do {
            events = try managedContext.fetch(fetchRequest)

            for e in events{
                let id = e.eventID!
                let name = e.name!
                let emoji = e.emoji!
                let includedTime = e.includedTime
                let date = e.date!
                let time = e.time!
                let created_at = e.created_at!
                let reminders = e.reminders!
                let colour = Int(e.colour)
                let progress = e.progress

                let event = Event(id,name,emoji,includedTime,date,time,created_at,reminders,colour,progress)
                if (utils.combineDateAndTime(event.date, event.time, event.includedTime) <= Date()){
                    completed.append(event)
                }else{
                    incomplete.append(event)
                }
                
                WidgetCenter.shared.reloadAllTimelines()

            }
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        completed.sort { (event1, event2) -> Bool in
            return utils.combineDateAndTime(event1.date, event1.time, event1.includedTime) < utils.combineDateAndTime(event2.date, event2.time, event2.includedTime)
        }
        
        incomplete.sort { (event1, event2) -> Bool in
            return utils.combineDateAndTime(event1.date, event1.time, event1.includedTime) < utils.combineDateAndTime(event2.date, event2.time, event2.includedTime)
        }
        
        eventList.append(contentsOf: incomplete)
        eventList.append(contentsOf: completed)

        return eventList
    }

    
}

