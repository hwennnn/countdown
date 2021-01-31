//
//  IntentHandler.swift
//  CountdownIntentExtension
//
//  Created by shadow on 31/1/21.
//

import Intents
import CoreData

class IntentHandler: INExtension{
//    func provideEventOptionsCollection(for intent: SelectEventIntent, with completion: @escaping (INObjectCollection<EventParam>?, Error?) -> Void) {
//        func provideEventOptionsCollections(for intent: SelectEventIntent, with completion : @escaping (INObjectCollection<EventParam>?,Error?) -> Void){
//            let events = fetchdata()
//            var eventParams:[EventParam] = []
//            for event in events{
//                eventParams.append(EventParam(event))
//            }
//            completion(INObjectCollection(items: eventParams),nil)
//        }
//    }
    
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
                eventList.append(event)

            }
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        eventList.sort { (event1, event2) -> Bool in
            return event1.date < event2.date
        }
        
        return eventList
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
      
        
        return self
    }
    
}
