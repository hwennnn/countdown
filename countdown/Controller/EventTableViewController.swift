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
            bannerTitle.text = "\(firstEvent.name) \(firstEvent.emoji.decodeEmoji)"
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
            performSegue(withIdentifier: "eventAction", sender: -1)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let event = eventList[indexPath.row]
        let remainingDateTime = combineDateAndTime(event.date, event.time, event.includedTime)

        cell.textLabel!.text = "\(event.name) \(event.emoji.decodeEmoji)"
        cell.detailTextLabel!.text = "\(dateFormat(event)) - \(calculateCountDown(remainingDateTime)) \(getCountDownDesc(remainingDateTime))"
        
        return cell
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let event:Event = eventList[indexPath.row]
    }
    
    func calculateCountDown(_ date:Date) -> Int {
        let remainingHours = Calendar.current.dateComponents([.hour], from: Date(), to: date).hour!
        if (remainingHours < 24){
            return remainingHours
        }
        return Calendar.current.dateComponents([.day], from: Date(), to: date).day!
    }
    
    func getCountDownDesc(_ date:Date) -> String {
        let remainingHours = Calendar.current.dateComponents([.hour], from: Date(), to: date).hour!
        if (remainingHours < 24){
            if (remainingHours >= 0 && remainingHours <= 1){
                return "hour left"
            }else{
                return "hours left"
            }
        } else{
            let remainingDays = Calendar.current.dateComponents([.day], from: Date(), to: date).day!
            if (remainingDays >= 0 && remainingDays <= 1){
                return "day left"
            }else{
                return "days left"
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
            self.eventList = self.eventController.retrieveAllEvent()
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
        if segue.identifier == "eventAction", let destination = segue.destination as? EventActionsViewController {
            if let s = sender as? Int{
                if (s == -1){
                    destination.currentEvent = self.firstEvent
                } else{
                    destination.currentEvent = self.eventList[s]
                }
            }
        }
    }
    
    func dateFormat(_ event:Event) -> String{
        let dateFormatter = DateFormatter() // set to local date (Singapore)
        dateFormatter.locale = Locale(identifier: "en_SG") // set desired format, note a is AM and FM format
        let dateFormatStyle:String = (event.includedTime) ? "d MMM yyyy h:mm a" : "d MMM yyyy"
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

