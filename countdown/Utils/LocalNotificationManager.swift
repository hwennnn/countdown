//
//  LocalNotificationManager.swift
//  countdown
//
//  Created by hwen on 21/1/21.
//

import Foundation
import UserNotifications

class LocalNotificationManager{
    var notifications = [Notification]()
    
    func listScheduledNotifications() {
        print("List notifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print(notification)
            }
        }
    }
    
    private func requestAuthorization(_ event: Event) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications(event)
            }
        }
    }
    
    func schedule(_ event: Event) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(event)
            case .authorized, .provisional:
                self.scheduleNotifications(event)
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications(_ event: Event) {
        let content = UNMutableNotificationContent()
        content.title = event.name
        content.sound = UNNotificationSound.default
        content.badge = 1

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (event.includedTime) ? "d MMM yyyy h:mm a" : "d MMM yyyy"
        let date = dateFormatter.string(from: event.date)
        content.body = "The event is due on \(date)" // xx hours
        
        // substract based on the reminder hours settings
//        switch (event.reminderPicked){
//            case 1:
//                // 30 minutes before
//                event.date.addTimeInterval(-(60*30))
//                break
//
//            case 2:
//                // 1 hour before
//                event.date.addTimeInterval(-(60*60))
//                break
//
//            case 3:
//                // 6 hours before
//                event.date.addTimeInterval(-(60*60*6))
//                break
//
//            case 4:
//                // 12 hours before
//                event.date.addTimeInterval(-(60*60*12))
//                break
//
//            default:
//                break
//
//        }
        
//        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: event.date)
//
//        let triggerDate = dateComponents
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//        let request = UNNotificationRequest(identifier: event.id!, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if let error = error {
//                print("Error \(error.localizedDescription)")
//            }
//
//            print("Notification scheduled! --- ID = \(request.identifier)")
//        }
        
    }
    
    func removeNotification(_ event:Event){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.id])
    }
}
