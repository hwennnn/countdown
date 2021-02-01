//
//  DateAndTimeConvertor.swift
//  countdown
//
//  Created by shadow on 1/2/21.
//

import Foundation

class Utils{
    
    var colourSchemeList:[String] = ["#DFC8F2", "#A0C5E8", "#AEFFBD", "#FFEAAB", "#5854D5", "#D92728"]
    
    func convertDateToString(date:Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
    //    df.dateFormat = "dd, dd MM YYYY"
        return df.string(from: date)
    }

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
}
