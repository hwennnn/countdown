//
//  EventTableViewController.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import UIKit

class EventTableViewController : UITableViewController{
    
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()
    
    var eventList:[Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
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
        cell.detailTextLabel!.text = "\(calculateCountDown(event.date)) days left"
        
        return cell
         
    }
    
    func calculateCountDown(_ date:Date) -> Int{
        return Calendar.current.dateComponents([.day], from: Date(), to: date).day!
    }
}
