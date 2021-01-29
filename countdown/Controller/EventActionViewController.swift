//
//  AddEventViewController.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import UIKit

class EventActionViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var includedTimeSwitch: UISwitch!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var reminderPicker: UIPickerView!
    
    let eventController = EventController()
    let firebaseDataController = FirebaseDataController()
    let notificationManager = LocalNotificationManager()
    
    var event:Event?
    var reminderList:[String] = ["No reminder", "30 minutes before", "1 hour before", "6 hours before", "12 hours before"]
    var picked:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (event != nil){
            includedTimeSwitch.isOn = event!.includedTime
            progressSlider.value = Float(event!.progress)
            eventTitle.text = event!.name
            datePicker.date = event!.date
            self.navigationItem.title = "Edit Event"
            self.actionButton.setTitle("Save", for: .normal)
//            self.picked = event!.reminderPicked
            
            
        }else{
            self.navigationItem.title = "Create Event"
            self.actionButton.setTitle("Create", for: .normal)
        }
        
        self.reminderPicker.delegate = self
        self.reminderPicker.dataSource = self
        self.reminderPicker.selectRow(picked, inComponent: 0, animated: true)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reminderList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        picked = row
    }
    
    @IBAction func actionEvent(_ sender: Any) {
        if (event != nil){
            updateEvent()
        }else{
            createEvent()
        }
    }
    
    func createEvent() {
        let title = eventTitle.text!
        let created_at = Date()
        let id = UUID().uuidString
        let progress = progressSlider.value
        let includedTime:Bool = includedTimeSwitch.isOn
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_SG")
        dateFormatter.dateFormat = (includedTime) ? "dd MMM yyyy h:mm a" : "dd MMM yyyy"
        let date = dateFormatter.date(from: dateFormatter.string(from: datePicker.date))
        
//        let event = Event(id, title, date!, created_at, progress, includedTime, picked)
//        eventController.addEvent(event)
//
//        if (picked != 0){
//            notificationManager.schedule(event)
//        }
//
//        firebaseDataController.insertEvent(event)
//
//        self.navigationController?.popViewController(animated: true)
    }
    
    func updateEvent() {
//        let title = eventTitle.text!
//        let date = datePicker.date
//        let progress = progressSlider.value
//        let includeTime = includedTimeSwitch.isOn
//
//        var updateNotification:Bool = false
//
//        if (picked == 0){
//            notificationManager.removeNotification(event!)
//        }else{
//            if (title != event!.name || date != event!.date || picked != event!.reminderPicked){
//                updateNotification = true
//            }
//        }
//
//        event!.name = title
//        event!.date = date
//        event!.progress = progress
//        event!.includedTime = includeTime
//        event!.reminderPicked = picked
//
//        if updateNotification{
//            notificationManager.removeNotification(event!)
//            notificationManager.schedule(event!)
//        }
//
//        eventController.updateEvent(event!)
//        firebaseDataController.updateEvent(event!)
//
//        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func updateIncludeTime(_ sender: Any) {
        if (includedTimeSwitch.isOn){
            datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        }else{
            datePicker.datePickerMode = UIDatePicker.Mode.date
        }
    }
}
