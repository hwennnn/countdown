//
//  EventTableViewController.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import UIKit
import SideMenu

class EventTableViewController : UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerRemaining: UILabel!
    @IBOutlet weak var bannerRemainingDesc: UILabel!
    @IBOutlet weak var bannerTitle: UILabel!
    @IBOutlet weak var bannerDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()
    let firebaseDataController = FirebaseDataController()
    let notificationManager = LocalNotificationManager()
    
    var firstEvent:Event?
    var eventList:[Event] = []
    var colourSchemeList:[String] = []
    
    @IBAction func didTapMenu(){
        present(appDelegate.menu!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tappedBanner(sender:)))
        self.bannerView.addGestureRecognizer(gesture)
        
        colourSchemeList = ["#DFC8F2", "#A0C5E8", "#AEFFBD", "#FFEAAB", "#5854D5", "#D92728"]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initEventList()
        
        self.tableView.reloadData()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        initEventList()
        self.tableView.reloadData()
    }
    
    func initEventList(){
        var fetchedList = eventController.retrieveAllEvent()
        
        if (fetchedList.count == 0){
            self.firstEvent = nil
            self.eventList = []
        }else{
            let firstEvent = fetchedList[0]
            self.firstEvent = firstEvent
            let remainingDateTime = combineDateAndTime(firstEvent.date, firstEvent.time, firstEvent.includedTime)
            
            bannerRemaining.text = "\(calculateCountDown(remainingDateTime))"
            bannerRemainingDesc.text = getCountDownDesc(remainingDateTime)
            bannerTitle.text = "\(firstEvent.emoji.decodeEmoji) \(firstEvent.name)"
            bannerDate.text = dateFormat(firstEvent)
            
            self.navigationController?.navigationBar.barTintColor = colourSchemeList[firstEvent.colour].colorWithHexString()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()
            self.bannerView.backgroundColor = colourSchemeList[firstEvent.colour].colorWithHexString()
            
            if (fetchedList.count == 1){
                self.eventList = []
            }else{
                fetchedList.removeFirst()
                self.eventList = fetchedList
            }
        }
        
    }
    
    @objc func tappedBanner(sender : UITapGestureRecognizer) {
        print("tapped")
        if (self.firstEvent != nil){
            performSegue(withIdentifier: "eventDetails", sender: nil)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell

        let event = eventList[indexPath.row]
        let remainingDateTime = combineDateAndTime(event.date, event.time, event.includedTime)
        
        cell.colourLine.backgroundColor = colourSchemeList[event.colour].colorWithHexString()
        cell.title.text = "\(event.emoji.decodeEmoji) \(event.name)"
        cell.date.text = "\(dateFormat(event))"
        cell.remaining.text = "\(calculateCountDown(remainingDateTime))"
        cell.remainingDesc.text = "\(getCountDownDesc(remainingDateTime))"
  
        return cell
         
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let event = self.eventList[indexPath.row]
            eventController.deleteEvent(event)
            firebaseDataController.deleteEvent(event)
            notificationManager.removeNotifications(event)
            initEventList()
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editHandler(indexPath.row)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [action])

    }
    
    func editHandler(_ index: Int){
        performSegue(withIdentifier: "eventAction", sender: index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventAction", let destination = segue.destination.children[0] as? EventActionsViewController {
            if let s = sender as? Int{
                if (s == -1){
                    destination.currentEvent = self.firstEvent
                } else{
                    destination.currentEvent = self.eventList[s]
                }
            }
        }
        
        if segue.identifier == "eventDetails", let destination = segue.destination.children[0] as? EventDetailsViewController {
            if let cell:EventTableViewCell = sender as? EventTableViewCell{
                let row = self.tableView.indexPath(for: cell)?.row
                destination.event = self.eventList[row!]
            }else{
                destination.event = self.firstEvent
            }
            // TODO: Add animation here (from left ro right)
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

extension String {
    private func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    func colorWithHexString(_ alpha:CGFloat = 1.0) -> UIColor {

        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(self))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0

        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}

