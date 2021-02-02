//
//  EventTableViewController.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import UIKit
import SideMenu
import WidgetKit

class EventTableViewController : UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    // Initialisation of storyboard objects
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerRemaining: UILabel!
    @IBOutlet weak var bannerRemainingDesc: UILabel!
    @IBOutlet weak var bannerTitle: UILabel!
    @IBOutlet weak var bannerDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // Initialisation of controllers
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()
    let firebaseDataController = FirebaseDataController()
    let notificationManager = LocalNotificationManager()
    let utils = Utility()
    
    var firstEvent:Event?
    var eventList:[Event] = []
    
    // This will open the side menu when the hamburger button on the top left is clicked.
    @IBAction func didTapMenu(){
        present(appDelegate.menu!, animated: true, completion: nil)
    }
    
    // This will initialise the delegate and gesture when the view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tappedBanner(sender:)))
        self.bannerView.addGestureRecognizer(gesture)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        initEventList()
        
        self.tableView.reloadData()
    }
 
    // This will initialise the eventList(table view data) when the view is starting to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initEventList()
        self.tableView.reloadData()
    }
    
    // This will initialise the eventList(table view data)
    func initEventList(){
        // Fetching the data from core data
        var fetchedList = eventController.retrieveAllEvent()
        
        // If the fetchedList count is 0, put both bannerview and tableview empty.
        // If the fetchedList count is 1, put the only event on the bannerview and left the tableview empty.
        // If the fetchedList count is more than 1, put the first event on the banner view and put the rest to the the tableview.
        if (fetchedList.count == 0){
            self.navigationController?.navigationBar.barTintColor = nil
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = nil
            self.bannerView.backgroundColor = nil
            
            bannerRemaining.text = "😭"
            bannerRemainingDesc.text = "Countdown is empty!"
            bannerTitle.text = ""
            bannerDate.text = ""
            
            self.firstEvent = nil
            self.eventList = []
        } else{
            let firstEvent = fetchedList[0]
            self.firstEvent = firstEvent
            let remainingDateTime = utils.combineDateAndTime(firstEvent.date, firstEvent.time, firstEvent.includedTime)
            
            bannerRemaining.text = "\(utils.calculateCountDown(remainingDateTime))"
            bannerRemainingDesc.text = utils.getCountDownDesc(remainingDateTime)
            bannerTitle.text = "\(firstEvent.emoji.decodeEmoji) \(firstEvent.name)"
            bannerDate.text = utils.convertDateToString(firstEvent)
            
            self.navigationController?.navigationBar.barTintColor = utils.colourSchemeList[firstEvent.colour].colorWithHexString()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()
            self.bannerView.backgroundColor = utils.colourSchemeList[firstEvent.colour].colorWithHexString()
            
            if (fetchedList.count == 1){
                self.eventList = []
            }else{
                fetchedList.removeFirst()
                self.eventList = fetchedList
            }
        }
    }
    
    // perform segue to event detail page when the banner is clicked (also the event is not NULL)
    @objc func tappedBanner(sender : UITapGestureRecognizer) {
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
    
    // Initialise the content of the table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell

        let event = eventList[indexPath.row]
        let remainingDateTime = utils.combineDateAndTime(event.date, event.time, event.includedTime)
        
        cell.colourLine.backgroundColor = utils.colourSchemeList[event.colour].colorWithHexString()
        cell.title.text = "\(event.emoji.decodeEmoji) \(event.name)"
        cell.date.text = "\(utils.convertDateToString(event))"
        cell.remaining.text = "\(utils.calculateCountDown(remainingDateTime))"
        cell.remainingDesc.text = "\(utils.getCountDownDesc(remainingDateTime))"
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Enable swipe right gesture for deleting event
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let event = self.eventList[indexPath.row]
            deleteAction(event)
        }
    }
    
    // Enable swipe left gesture for editing event
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editHandler(indexPath.row)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [action])

    }
    
    // Pop an alert to the user when the user attempts to delete the event
    func deleteAction(_ event:Event){
        let alertView = UIAlertController(title: "Delete Countdown", message: "Are you sure you want to delete \(event.name)?", preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "No",style: UIAlertAction.Style.default, handler: { _ in }))
        alertView.addAction(UIAlertAction(title: "Yes",style: UIAlertAction.Style.default, handler: { _ in self.deleteEvent(event) }))
        
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    // This function will call all the controllers to reflect on the event is deleted
    func deleteEvent(_ event:Event){
        eventController.deleteEvent(event)
        firebaseDataController.deleteEvent(event)
        notificationManager.removeNotifications(event)
        initEventList()
        self.tableView.reloadData()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // Swipe left will perform segue to edit the event
    func editHandler(_ index: Int){
        performSegue(withIdentifier: "eventAction", sender: index)
    }
    
    // Parse in the event to the destination eventController when performing segue
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
        
        if segue.identifier == "eventDetails", let destination = segue.destination as? EventDetailsViewController {
            if let cell:EventTableViewCell = sender as? EventTableViewCell{
                let row = self.tableView.indexPath(for: cell)?.row
                destination.event = self.eventList[row!]
            }else{
                destination.event = self.firstEvent
            }
        }
    }
}
