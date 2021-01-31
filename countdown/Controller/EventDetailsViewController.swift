//
//  EventDetailsViewController.swift
//  countdown
//
//  Created by hwen on 31/1/21.
//

import Foundation
import UIKit

class EventDetailsViewController:UIViewController {
    
    var event:Event?
    var colourSchemeList:[String] = []
    @IBOutlet weak var iconField: UILabel!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var dateField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colourSchemeList = ["#DFC8F2", "#A0C5E8", "#AEFFBD", "#FFEAAB", "#5854D5", "#D92728"]
        
        if (event != nil){
            self.view.backgroundColor = colourSchemeList[event!.colour].colorWithHexString()
            self.iconField.text = event!.emoji.decodeEmoji
            self.titleField.text = event!.name
            self.dateField.text = dateFormat(event!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func back(){
        // TODO: add animation here (from right to left)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEvent", let destination = segue.destination.children[0] as? EventActionsViewController {
            if (event != nil){
                destination.currentEvent = event
            }
        }
    }
    
    func dateFormat(_ event:Event) -> String{
        let dateFormatter = DateFormatter() // set to local date (Singapore)
        dateFormatter.locale = Locale(identifier: "en_SG") // set desired format, note a is AM and FM format
        let dateFormatStyle:String = (event.includedTime) ? "EE, d MMM yyyy h:mm a" : "EE, d MMM yyyy"
        dateFormatter.dateFormat = dateFormatStyle // convert date to String
        let datevalue = dateFormatter.string(from: combineDateAndTime(event.date, event.time, event.includedTime))
        
        return datevalue
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
