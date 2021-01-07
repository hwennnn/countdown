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
        
    func addEvent(_ event:Event){
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CDEvent", in: context)!
        
        let newEvent = NSManagedObject(entity: entity, insertInto: context) as! CDEvent
        newEvent.setValue(event.id, forKey: "eventID")
        newEvent.setValue(event.name, forKey: "name")
        newEvent.setValue(event.date, forKey: "date")
        newEvent.setValue(event.created_at, forKey: "created_at")
        
        do{
            try context.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateEvent(_ event:Event){
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDEvent")
        
        // to be changed using id to find the speficic event instead using unique name
        fetchRequest.predicate = NSPredicate(format: "eventID = %@", event.id!)
        do {
            let fetched = try context.fetch(fetchRequest)
            
            let r = fetched[0] as NSManagedObject
            r.setValue(event.name, forKey: "name")
            r.setValue(event.date, forKey: "date")
            
            do{
                try context.save()
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteEvent(_ event:Event){
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDEvent")
        
        fetchRequest.predicate = NSPredicate(format: "eventID = %@", event.id!)
        
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
    
    func retrieveAllEvent() -> [Event]{
        var eventList:[Event] = []
        var events:[CDEvent] = []
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        let fetchRequest = NSFetchRequest<CDEvent>(entityName: "CDEvent")
        do {
            events = try context.fetch(fetchRequest)

            for e in events{
                let id = e.eventID!
                let name = e.name!
                let date = e.date!
                let created_at = e.created_at!
                let groups:[Group] = []
                
                let event = Event(id,name,date,created_at,groups)
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
}
