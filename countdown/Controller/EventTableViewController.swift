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
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()
    let firebaseDataController = FirebaseDataController()
    let notificationManager = LocalNotificationManager()
    
    var eventList:[Event] = []
    
    @IBAction func didTapMenu(){
        present(appDelegate.menu!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        self.eventList = eventController.retrieveAllEvent()
        self.tableView.reloadData()
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

        cell.textLabel!.text = "\(event.name) \(event.emoji.decodeEmoji)"
        cell.detailTextLabel!.text = "\(dateFormat(event)) - \(calculateCountDown(event.date)) days left"
        
        return cell
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let event:Event = eventList[indexPath.row]
    }
    
    func calculateCountDown(_ date:Date) -> Int{
        return Calendar.current.dateComponents([.day], from: Date(), to: date).day!
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
                destination.currentEvent = self.eventList[s]
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
