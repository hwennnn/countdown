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
    var ref: DatabaseReference! = Database.database().reference()
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    func insertEvent(_ event:Event){
        let uid = appDelegate.currentUser?.uid
        let newEvent = ["name": event.name, "date": currentTimeInMiliseconds(event.date), "created_at": currentTimeInMiliseconds(event.created_at), "progress": event.progress, "includeTime": event.includedTime, "reminderPicked": event.reminderPicked] as [String : Any]
        self.ref.child("events").child(uid!).child(event.id!).setValue(newEvent)
    }
    
    func deleteEvent(_ event:Event){
        let uid = appDelegate.currentUser?.uid
        self.ref.child("events").child(uid!).child(event.id!).removeValue()
    }
    
    func updateEvent(_ event:Event){
        let uid = appDelegate.currentUser?.uid
        let updatedEvent = ["name": event.name, "date": currentTimeInMiliseconds(event.date), "created_at": currentTimeInMiliseconds(event.created_at), "progress": event.progress, "includeTime": event.includedTime, "reminderPicked": event.reminderPicked] as [String : Any]
        self.ref.child("events").child(uid!).child(event.id!).updateChildValues(updatedEvent)
    }
    
    func currentTimeInMiliseconds(_ date:Date) -> Int {
        let since1970 = date.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
}
