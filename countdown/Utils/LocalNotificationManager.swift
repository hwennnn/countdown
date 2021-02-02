//
//  LocalNotificationManager.swift
//  countdown
//
//  Created by hwen on 21/1/21.
//

import Foundation
import UserNotifications

class LocalNotificationManager{
    
    let utils = Utility()
    
    // This will list out all the pending notifications
    func listScheduledNotifications() {
        print("List notifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print(notification.identifier)
            }
        }
    }
    
    // This will check whether the application is granted authorization to send out notifications. If so, it will schedule notifications.
    private func requestAuthorization(_ event: Event) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if granted == true && error == nil {
                self.scheduleNotifications(event)
            }
        }
    }
    
    // This function is accessible to the main app. It will request authorization or directly schedule the event's notifications based on the notification settings.
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
    
    // This serves as a helper function to schedule notifications by passing different index(which indicates different notification timing) to the main schedule function.
    private func scheduleNotifications(_ event:Event){
        // set reminder when the countdown finishes
        scheduleNotification(event, -1)
        
        // set reminders based on the user settings
        let reminders = utils.stringToArray(event.reminders)
        for (index, needSet) in reminders.enumerated(){
            if (needSet){
                scheduleNotification(event, index)
            }
        }
    }
    
    // This is the main schedule function. It will wrap out the event details(title and date) and send a pending to request to the nofication center for sending out the notifications later.
    private func scheduleNotification(_ event: Event, _ index: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Countdown - \(event.name)"
        content.sound = UNNotificationSound.default
        content.badge = 1

        var combinedDate = utils.combineDateAndTime(event.date, event.time, event.includedTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_SG")
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: combinedDate)
        
        // customise different content based on the notification timing
        if (index == -1){
            content.body = "The countdown has completed"
        }else{
            var desc = ""
            switch (index){
                case 0:
                    desc = "in 30 minutes"
                    break
                    
                case 1:
                    desc = "in 1 hour"
                    break
                
                case 2:
                    desc = "tomorrow"
                    break
                    
                default:
                    break
            }
            
            content.body = "The countdown will be due \(desc) @ \(date) "
        }
        
        
        // substract based on the reminder hours settings
        switch (index){
            case 0:
                // 30 minutes before
                combinedDate.addTimeInterval(-(60*30))
                break

            case 1:
                // 1 hour before
                combinedDate.addTimeInterval(-(60*60))
                break

            case 2:
                // 1 day before
                combinedDate.addTimeInterval(-(60*60*24))
                break

            default:
                break

        }
        
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: combinedDate)

        let triggerDate = dateComponents
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        // use the index as a suffix to make the notificationID unique
        let notificationID = (index == -1) ? event.id : "\(event.id)\(index)"
        print(notificationID)
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }

            print("Notification scheduled! --- ID = \(request.identifier)")
        }
        
    }
    
    // This function remove all notifications. This will be called when logged out.
    func removeAllNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // This function will remove all notification for a particular event. This will be called when updating or deleting a event.
    func removeNotifications(_ event:Event){
        removeNotification(event, -1)
        
        let reminders = utils.stringToArray(event.reminders)
        for (index, _) in reminders.enumerated(){
            removeNotification(event, index)
        }
    }
    
    // This function will remove the notification based on the identifier using the suffix index.
    private func removeNotification(_ event:Event, _ index:Int){
        let notificationID = (index == -1) ? event.id : "\(event.id)\(index)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
    }
}
