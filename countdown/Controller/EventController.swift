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
        newEvent.setValue(event.name, forKey: "name")
        newEvent.setValue(event.date, forKey: "date")
        newEvent.setValue(event.created_at, forKey: "created_at")
        
        do{
            try context.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
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
                let name = e.name!
                let date = e.date!
                let created_at = e.created_at!
                let groups:[Group] = []
                
                let event = Event(name,date,created_at,groups)
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
