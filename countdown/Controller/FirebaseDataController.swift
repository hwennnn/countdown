//
//  FirebaseDataController.swift
//  countdown
//
//  Created by hwen on 28/1/21.
//

import Foundation
import Firebase
import UIKit

class FirebaseDataController: UIViewController{
    
    // Initialisation of controllers
    var ref: DatabaseReference! = Database.database().reference()
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()
    let notificationManger = LocalNotificationManager()
    
    // This will create a new event entry in firebase
    func insertEvent(_ event:Event){
        let uid = appDelegate.currentUser?.uid
        let newEvent = ["name": event.name, "emoji": event.emoji, "includedTime": event.includedTime, "date": currentTimeInMiliseconds(event.date), "time": currentTimeInMiliseconds(event.time), "created_at": currentTimeInMiliseconds(event.created_at), "reminders": event.reminders, "colour": event.colour, "progress": event.progress as Float] as [String : Any]
        
        self.ref.child("events").child(uid!).child(event.id).setValue(newEvent)
    }
    
    // This will delete the event from the firebase using its identifier.
    func deleteEvent(_ event:Event){
        let uid = appDelegate.currentUser?.uid
        self.ref.child("events").child(uid!).child(event.id).removeValue()
    }
    
    // This will update the existing event in the firebase based on its identifier.
    func updateEvent(_ event:Event){
        let uid = appDelegate.currentUser?.uid
        let updatedEvent = ["name": event.name, "emoji": event.emoji, "includedTime": event.includedTime, "date": currentTimeInMiliseconds(event.date), "time": currentTimeInMiliseconds(event.time), "created_at": currentTimeInMiliseconds(event.created_at), "reminders": event.reminders, "colour": event.colour, "progress": event.progress as Float] as [String : Any]
        
        self.ref.child("events").child(uid!).child(event.id).updateChildValues(updatedEvent)
    }
    
    // THis will fetch all events from firebase when there is a new login. This function will insert the fetched event to coredata. There is a completion handler which will do a callback to the main application to load the main page after every event is inserted to the core data.
    func fetchAllEvents(completion: @escaping (_ success: Bool) -> Void){
        let uid = Auth.auth().currentUser?.uid
        ref.child("events").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in

            let events = snapshot.value as? [String : Any]
            if events != nil{
                for event in events!{
                    let id = event.key
                    let value = event.value as! [String: Any]
                    
                    let name = value["name"] as! String
                    let emoji = value["emoji"] as! String
                    let includedTime = value["includedTime"] as! Bool
                    let dateMs = value["date"] as! Int
                    let timeMs = value["time"] as! Int
                    let createdAtMs = value["created_at"] as! Int
                    let reminders = value["reminders"] as! String
                    let colour = value["colour"] as! Int
                    let progress = value["progress"] as! Float
                    
                    let date:Date = self.dateFromMilliseconds(dateMs)
                    let time:Date = self.dateFromMilliseconds(timeMs)
                    let created_at:Date = self.dateFromMilliseconds(createdAtMs)
                    
                    let newEvent = Event(id,name,emoji,includedTime,date,time,created_at,reminders,colour,progress)
                    self.eventController.addEvent(newEvent)
                    self.notificationManger.schedule(newEvent)
                }
            }
            // callback when finished fetching all events
            completion(true)
        }) { (error) in
          print(error.localizedDescription)
          }
    }
    
    // This functions will return the miliseconds from data.
    func currentTimeInMiliseconds(_ date:Date) -> Int {
        let since1970 = date.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    // This function will return the data from miliseconds.
    func dateFromMilliseconds(_ ms:Int ) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(ms/1000))
    }
    
}

