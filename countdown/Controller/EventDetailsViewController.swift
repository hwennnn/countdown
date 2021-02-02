//
//  EventDetailsViewController.swift
//  countdown
//
//  Created by hwen on 31/1/21.
//

import Foundation
import UIKit
import WidgetKit

class EventDetailsViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    // Initialisation of objects and array
    var detailsList:[(String, Int)] = []
    var event:Event?
    var timer:Timer?
    
    // Initialisation of controllers
    let eventController = EventController()
    let firebaseDataController = FirebaseDataController()
    let notificationManager = LocalNotificationManager()
    let utils = Utility()
    
    // Initialisation of storyboard objects
    @IBOutlet weak var iconField: UILabel!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Initialise when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (event != nil){
            self.view.backgroundColor = utils.colourSchemeList[event!.colour].colorWithHexString()
            self.iconField.text = event!.emoji.decodeEmoji
            self.titleField.text = event!.name
            self.dateField.text = utils.convertDateToString(event!)
        }
        
        self.detailsList = generateRemaining()
        
        self.collectionView.backgroundColor = utils.colourSchemeList[event!.colour].colorWithHexString()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
       }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        
        if (event != nil){
            self.view.backgroundColor = utils.colourSchemeList[event!.colour].colorWithHexString()
            self.iconField.text = event!.emoji.decodeEmoji
            self.titleField.text = event!.name
            self.dateField.text = utils.convertDateToString(event!)
        }
        self.collectionView.backgroundColor = utils.colourSchemeList[event!.colour].colorWithHexString()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateDetails), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // Invalidate the timer when the view disappeared.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        timer?.invalidate()
    }
    
    // Invalidate the timer when received memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        timer?.invalidate()
    }
    
    // Invalidate the timer when the application goes to background
    @objc func didEnterBackground() {
        print("didEnterBackground")
        timer?.invalidate()
   }
    
    // Re-initialsie the timer again when the application once becomes active
    @objc func didBecomeActive() {
        print("didBecomeActive")
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateDetails), userInfo: nil, repeats: true)
    }
    
    // Timer function to be called every second to show the current countdown
    @objc func updateDetails(){
        self.detailsList = generateRemaining()
        self.collectionView.reloadData()
    }
    
    // Gesture recognizer which enablse swipe left to go back main page
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.detailsList.count
    }
    
    // Initialisation of collection view cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventDetail", for: indexPath) as! EventDetailCollectionViewCell
        let detail = self.detailsList[indexPath.row]
        cell.remaining.text = "\(detail.1)"
        cell.remainingDesc.text = detail.0
        
        return cell
    }
    
    // Generate the collection view cell data by returning the countdown for each label.
    func generateRemaining() -> [(String, Int)] {
        var res:[(String, Int)] = []
        
        let combinedDate = utils.combineDateAndTime(event!.date, event!.time, event!.includedTime)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: combinedDate)
        
        let desc:[String] = ["year", "month", "day", "hour", "minute", "second"]
        let years = abs(components.year!)
        let months = abs(components.month!)
        let days = abs(components.day!)
        let hours = abs(components.hour!)
        let minutes = abs(components.minute!)
        let seconds = abs(components.second!)
        let dates:[Int] = [years, months, days, hours, minutes, seconds]
        
        for (suffix, d) in zip(desc, dates){
            let s = (d == 0 || d == 1) ? suffix : "\(suffix)s"
            res.append((s, d))
        }
        
        return res
    }
    
    // Pop the view controller to go back main page when the "back" button is clicked.
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // Delete action to alert user if they really want to delete that event.
    @IBAction func deleteAction(){
        let alertView = UIAlertController(title: "Delete Countdown", message: "Are you sure you want to delete \(event!.name)?", preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "No",style: UIAlertAction.Style.default, handler: { _ in }))
        alertView.addAction(UIAlertAction(title: "Yes",style: UIAlertAction.Style.default, handler: { _ in self.deleteEvent() }))
        
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    // This function will call all the controllers to reflect on the event is deleted
    func deleteEvent(){
        eventController.deleteEvent(event!)
        firebaseDataController.deleteEvent(event!)
        notificationManager.removeNotifications(event!)
        self.navigationController?.popViewController(animated: true)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // Parse in the event to the destination eventController when performing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEvent", let destination = segue.destination.children[0] as? EventActionsViewController {
            if (event != nil){
                destination.currentEvent = event
            }
        }
    }
}
