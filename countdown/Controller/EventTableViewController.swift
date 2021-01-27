//
//  EventTableViewController.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import UIKit
import SideMenu

class EventTableViewController : UITableViewController{
    
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()
    let notificationManager = LocalNotificationManager()
    
    var menu: UISideMenuNavigationController?
    
    var eventList:[Event] = []
    
    @IBAction func didTapMenu(){
        present(menu!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        
        // Define the menu
        menu = storyboard!.instantiateViewController(identifier: "LeftMenu") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuLeftNavigationController = menu
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.view)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view)
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
        SideMenuManager.default.menuWidth = view.frame.width * 0.7
        SideMenuManager.default.menuLeftNavigationController?.sideMenuManager.menuPresentMode = .menuSlideIn
    }
 
    override func viewDidAppear(_ animated: Bool) {
        self.eventList = eventController.retrieveAllEvent()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let event = eventList[indexPath.row]

        cell.textLabel!.text = event.name
        cell.detailTextLabel!.text = "\(dateFormat(event)) - \(calculateCountDown(event.date)) days left Progress:\(Int32(event.progress))%"
        
        return cell
         
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let event:Event = eventList[indexPath.row]
        notificationManager.listScheduledNotifications()
    }
    
    func calculateCountDown(_ date:Date) -> Int{
        return Calendar.current.dateComponents([.day], from: Date(), to: date).day!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let event = self.eventList[indexPath.row]
            eventController.deleteEvent(event)
            notificationManager.removeNotification(event)
            self.eventList = self.eventController.retrieveAllEvent()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editHandler(indexPath.row)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [action])

    }
    
    func editHandler(_ index: Int){
        performSegue(withIdentifier: "createEvent", sender: index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createEvent", let destination = segue.destination as? EventActionViewController {
            if let s = sender as? Int{
                destination.event = self.eventList[s]
            }
        }
    }
    
    func dateFormat(_ event:Event) -> String{
        let dateFormatter = DateFormatter() // set to local date (Singapore)
        dateFormatter.locale = Locale(identifier: "en_SG") // set desired format, note a is AM and FM format
        let dateFormatStyle:String = (event.includedTime) ? "d MMM yyyy h:mm a" : "d MMM yyyy"
        dateFormatter.dateFormat = dateFormatStyle // convert date to String
        let datevalue = dateFormatter.string(from: event.date)
        
        return datevalue
    }
}
