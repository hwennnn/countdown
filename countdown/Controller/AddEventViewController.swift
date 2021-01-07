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
    
    let eventController = EventController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createEvent(_ sender: Any) {
        let title = eventTitle.text!
        let date = datePicker.date
        let created_at = Date()
        let groups:[Group] = []
        
        let event = Event(title, date, created_at, groups)
        eventController.addEvent(event)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
