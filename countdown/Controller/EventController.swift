//
//  EventController.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import UIKit
import CoreData

class EventController: UIViewController{
    
    // Use the utility object
    let utils = Utility()
    
    // This will create a new event entry in core data
    func addEvent(_ event:Event){
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "CDEvent", in: context)!

        let newEvent = NSManagedObject(entity: entity, insertInto: context) as! CDEvent
        
        newEvent.setValue(event.id, forKey: "eventID")
        newEvent.setValue(event.name, forKey: "name")
        newEvent.setValue(event.emoji, forKey: "emoji")
        newEvent.setValue(event.includedTime, forKey: "includedTime")
        newEvent.setValue(event.date, forKey: "date")
        newEvent.setValue(event.time, forKey: "time")
        newEvent.setValue(event.created_at, forKey: "created_at")
        newEvent.setValue(event.reminders, forKey: "reminders")
        newEvent.setValue(event.colour, forKey: "colour")
        newEvent.setValue(event.progress, forKey: "progress")

        do{
            try context.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // This will update the existing event in the core data based on its identifier.
    func updateEvent(_ event:Event){
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDEvent")

        fetchRequest.predicate = NSPredicate(format: "eventID = %@", event.id)
        do {
            let fetched = try context.fetch(fetchRequest)

            let r = fetched[0] as NSManagedObject
            r.setValue(event.id, forKey: "eventID")
            r.setValue(event.name, forKey: "name")
            r.setValue(event.emoji, forKey: "emoji")
            r.setValue(event.includedTime, forKey: "includedTime")
            r.setValue(event.date, forKey: "date")
            r.setValue(event.time, forKey: "time")
            r.setValue(event.created_at, forKey: "created_at")
            r.setValue(event.reminders, forKey: "reminders")
            r.setValue(event.colour, forKey: "colour")
            r.setValue(event.progress, forKey: "progress")

            do{
                try context.save()
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }

        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    // This will delete the event from the core data using its identifier.
    func deleteEvent(_ event:Event){
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDEvent")

        fetchRequest.predicate = NSPredicate(format: "eventID = %@", event.id)

        do {
            let fetched = try context.fetch(fetchRequest)

            let f = fetched[0] as NSManagedObject
            context.delete(f)

            do{
                try context.save()
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }

        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // This will fetch all the events data from the core data.
    func retrieveAllEvent() -> [Event]{
        var eventList:[Event] = []
        var completed:[Event] = []
        var incomplete:[Event] = []
        var events:[CDEvent] = []
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<CDEvent>(entityName: "CDEvent")
        do {
            events = try context.fetch(fetchRequest)

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

            }
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // Sort the event data
        // First sort both completed and incomplete events in two different
        // Prioritise the incomplete first by first putting in the incomplete and thereafter completed
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
    
    
    // This will clear all the event table data from the core data. This is called when logging out.
    func deleteAllEvents() {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDEvent>(entityName: "CDEvent")
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results:[CDEvent] = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject
                context.delete(managedObjectData)
            }
            
            do{
                try context.save()
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Detele all data in Event Table error : \(error) \(error.userInfo)")
        }
    }
}
