//
//  Utility.swift
//  countdown
//
//  Created by zachary on 1/2/21.
//

 import Foundation

// Utility class
 class Utility {
    
    var colourSchemeList:[String] = ["#DFC8F2", "#A0C5E8", "#AEFFBD","#FFEAAB", "#5854D5", "#D92728"]

    // This will convert the date to string with the format.
    func convertDateToString(_ event:Event) -> String{
        let dateFormatter = DateFormatter() // set to local date (Singapore)
        dateFormatter.locale = Locale(identifier: "en_SG") // set desired format, note a is AM and FM format
        let dateFormatStyle:String = (event.includedTime) ? "EE, d MMM yyyy h:mm a" : "EE, d MMM yyyy"
        dateFormatter.dateFormat = dateFormatStyle // convert date to String
        return dateFormatter.string(from: combineDateAndTime(event.date, event.time, event.includedTime))
    }

    // This will calculate how many countdown(minutes/hours/days/months) left based on the date parsed in.
    func calculateCountDown(_ date:Date) -> Int {
        let remainingHours = abs(Calendar.current.dateComponents([.hour], from: Date(), to: date).hour!)
        if (remainingHours < 24){
            if (remainingHours == 0){
                let remainingMinutes = Calendar.current.dateComponents([.minute], from: Date(), to: date).minute!
                return abs(remainingMinutes)
            }
            
            return abs(remainingHours)
        }
        
        let remainingDays = abs(Calendar.current.dateComponents([.day], from: Date(), to: date).day!)
        return remainingDays
    }
    
    // This will return the description string of the countdown left based on the date parsed in.
    func getCountDownDesc(_ date:Date) -> String {
        let remainingHours = Calendar.current.dateComponents([.hour], from: Date(), to: date).hour!
        var suffix = (remainingHours >= 0) ? "left" : "ago"
        
        if (abs(remainingHours) < 24){
            if (remainingHours == 0){
                let remainingMinutes = Calendar.current.dateComponents([.minute], from: Date(), to: date).minute!
                if (remainingMinutes == 0){
                    return "min \(suffix)"
                } else{
                    suffix = (remainingMinutes > 0) ? "left" : "ago"
                    return "mins \(suffix)"
                }
            }
            
            if (remainingHours == 1){
                return "hour \(suffix)"
            }else{
                return "hours \(suffix)"
            }
        } else{
            let remainingDays = Calendar.current.dateComponents([.day], from: Date(), to: date).day!
            if (remainingDays == 1){
                return "day \(suffix)"
            }else{
                suffix = (remainingDays > 0) ? "left" : "ago"
                return "days \(suffix)"
            }
        }
    }

    // This function will combine date and time and return a combined date.
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
    
    // This function will convert string to array using seperating string function.
    func stringToArray(_ s:String) -> [Bool] {
        let stringArray:[String] = s.components(separatedBy: ",")
        return stringArray.map{Bool($0)!}
    }
    
    // This function will convert array to string using joining string function.
    func arrayToString(_ array:[Bool]) -> String {
        let stringArray = array.map{String($0)}
        return stringArray.joined(separator: ",")
    }
    
    
}
                
