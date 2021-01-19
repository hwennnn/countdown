//
//  AddEventViewController.swift
//  countdown
//
//  Created by hwen on 7/1/21.
//

import Foundation
import UIKit

class AddEventViewController : UIViewController{
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var includedTimeSwitch: UISwitch!
    @IBOutlet weak var progressSlider: UISlider!
    
    let eventController = EventController()
    
    var event:Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (event != nil){
            eventTitle.text = event!.name
            datePicker.date = event!.date
            self.navigationItem.title = "Edit"
            self.createBtn.isHidden = true
            self.updateBtn.isHidden = false
        }else{
            self.navigationItem.title = "Create"
            self.createBtn.isHidden = false
            self.updateBtn.isHidden = true
        }
    }
    
    @IBAction func createEvent(_ sender: Any) {
        let title = eventTitle.text!
        let date = datePicker.date
        let created_at = Date()
        let id = String(created_at.timeIntervalSince1970)
        let group = Group()
        let progress:Int32 = Int32(progressSlider.value)
        let includedTime:Bool = includedTimeSwitch.isOn
        print(includedTimeSwitch.isOn)
        
        let event = Event(id, title, date, created_at, group, progress, includedTime)
        eventController.addEvent(event)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateEvent(_ sender: Any) {
        let title = eventTitle.text!
        let date = datePicker.date
        
        event!.name = title
        event!.date = date
        
        eventController.updateEvent(event!)
        
        self.navigationController?.popViewController(animated: true)
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
