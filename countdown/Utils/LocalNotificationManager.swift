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
                print(notification.identifier)
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
    
    private func scheduleNotifications(_ event:Event){
        // set reminder when the countdown finishes
        scheduleNotification(event, -1)
        
        // set reminders based on the user settings
        let reminders = stringToArray(event.reminders)
        for (index, needSet) in reminders.enumerated(){
            if (needSet){
                scheduleNotification(event, index)
            }
        }
    }
    
    private func scheduleNotification(_ event: Event, _ index: Int) {
        let content = UNMutableNotificationContent()
        content.title = event.name
        content.sound = UNNotificationSound.default
        content.badge = 1

        var combinedDate = combineDateAndTime(event.date, event.time, event.includedTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_SG")
        dateFormatter.dateFormat = (event.includedTime) ? "d MMM yyyy h:mm a" : "d MMM yyyy"
        let date = dateFormatter.string(from: combinedDate)
        content.body = "The event is due on \(date)" // xx hours
        
//         substract based on the reminder hours settings
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
    
    func removeAllNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func removeNotifications(_ event:Event){
        removeNotification(event, -1)
        
        let reminders = stringToArray(event.reminders)
        for (index, _) in reminders.enumerated(){
            removeNotification(event, index)
        }
    }
    
    private func removeNotification(_ event:Event, _ index:Int){
        let notificationID = (index == -1) ? event.id : "\(event.id)\(index)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
    }
    
    func combineDateAndTime(_ date: Date, _ time: Date, _ includedTime:Bool) -> Date {
        
        let calendar = NSCalendar.current

        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        
        if (includedTime){
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
        }
        
        return calendar.date(from: components)!
    }
    
    func stringToArray(_ s:String) -> [Bool] {
        let stringArray:[String] = s.components(separatedBy: ",")
        return stringArray.map{Bool($0)!}
    }
}
