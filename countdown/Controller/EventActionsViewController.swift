//
//  EventActionsViewController.swift
//  countdown
//
//  Created by hwen on 29/1/21.
//

import Foundation
import UIKit
import ISEmojiView
import WidgetKit

class EventActionsViewController: UIViewController, UITextFieldDelegate, EmojiViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var emojiField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var isIncludeTime: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    @IBOutlet weak var reminder1: UISwitch!
    @IBOutlet weak var reminder2: UISwitch!
    @IBOutlet weak var reminder3: UISwitch!
    
    @IBOutlet weak var colour1: UIButton!
    @IBOutlet weak var colour2: UIButton!
    @IBOutlet weak var colour3: UIButton!
    @IBOutlet weak var colour4: UIButton!
    @IBOutlet weak var colour5: UIButton!
    @IBOutlet weak var colour6: UIButton!
    
    var currentEvent:Event?
    var colourList:[UIButton] = []
    var selectedColour:Int = 0
    var reminderSwitches:[UISwitch] = []
    
    let eventController = EventController()
    let firebaseDataController = FirebaseDataController()
    let notificationManager = LocalNotificationManager()
    let utils = Utility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colourList = [colour1, colour2, colour3, colour4, colour5, colour6]
        reminderSwitches = [reminder1, reminder2, reminder3]
        
        // close the keyboard when dragging the screen
        scrollView.keyboardDismissMode = .interactive
        scrollView.keyboardDismissMode = .onDrag
        
        eventTitle.delegate = self
        emojiField.delegate = self
        emojiField.tintColor = .clear
        
        // initialise the emoji keyboard settings
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        emojiField.inputView = emojiView
        
        datePicker.timeZone = NSTimeZone.local
        timePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = UIDatePicker.Mode.date
        timePicker.datePickerMode = UIDatePicker.Mode.time
        
        if (currentEvent != nil){
            eventTitle.text = currentEvent!.name
            emojiField.text = currentEvent!.emoji.decodeEmoji
            isIncludeTime.isOn = !currentEvent!.includedTime
            datePicker.date = currentEvent!.date
            timePicker.date = currentEvent!.time
            let reminders = stringToArray(currentEvent!.reminders)
            for (index, isSet) in reminders.enumerated(){
                if (isSet){
                    reminderSwitches[index].isOn = true
                }
            }
            selectedColour = currentEvent!.colour
            self.navigationItem.title = "Edit Countdown"
            self.actionButton.title = "Save"
        }else{
            self.navigationItem.title = "Create Countdown"
            self.actionButton.title = "Create"
        }
        
        if (isIncludeTime.isOn){
            self.timePicker.isHidden = true
        }else{
            self.timePicker.isHidden = false
        }
        
        initColourButtons(colourList)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        emojiField.text = ""
        emojiField.insertText(emoji)
    }

    // callback when tap change keyboard button on keyboard
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        emojiField.inputView = nil
        emojiField.keyboardType = .default
        emojiField.reloadInputViews()
    }

    // callback when tap dismiss button on keyboard
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        emojiField.resignFirstResponder()
    }
    
    func initColourButtons(_ buttons:[UIButton]){
        for (button, colourHex) in zip(buttons, utils.colourSchemeList){
            button.backgroundColor = colourHex.colorWithHexString()
        }
        
        for button in buttons{
            button.layer.cornerRadius = 15
        }
        buttons[selectedColour].layer.borderWidth = 1
        buttons[selectedColour].layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func updateIncludeTime(_ sender: Any) {
        if (isIncludeTime.isOn){
            self.timePicker.isHidden = true
        }else{
            self.timePicker.isHidden = false
        }
    }
    
    @IBAction func colourClicked(sender: UIButton){
        for (index,button) in colourList.enumerated(){
            if (button.tag == sender.tag){
                selectedColour = index
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
            }else{
                button.layer.borderWidth = 0
                button.layer.borderColor = nil
            }
        }
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionEvent(_ sender: Any){
        if (currentEvent != nil){
            updateEvent()
        }else{
            createEvent()
        }
    }
    
    func createEvent(){
        let id = UUID().uuidString
        let title = eventTitle.text!
        
        if (title.isEmpty){
            popAlert("Blank field", "Please enter a title for the countdown!")
            return
        }
        
        if (title.count > 30){
            popAlert("Invalid name", "Please enter a shorter name for the countdown!")
            return
        }
        
        let emoji = (emojiField.text!).encodeEmoji
        
        let includedTime = !isIncludeTime.isOn
        let date = datePicker.date
        let time = timePicker.date
        let created_at = Date()
        
        let reminders = [reminder1.isOn, reminder2.isOn, reminder3.isOn]
        let remindersAsString = arrayToString(reminders)

        let colour = selectedColour
        let progress:Float = 0
        
        let newEvent = Event(id, title, emoji, includedTime, date, time, created_at, remindersAsString, colour, progress)
        
        eventController.addEvent(newEvent)
        firebaseDataController.insertEvent(newEvent)
        
        notificationManager.schedule(newEvent)
        WidgetCenter.shared.reloadAllTimelines()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateEvent(){
        let title = eventTitle.text!
        
        if (title.isEmpty){
            popAlert("Blank field", "Please enter a title for the countdown!")
            return
        }
        
        if (title.count > 30){
            popAlert("Invalid name", "Please enter a shorter name for the countdown!")
            return
        }
        
        let emoji = (emojiField.text!).encodeEmoji
        
        let includedTime = !isIncludeTime.isOn
        let date = datePicker.date
        let time = timePicker.date
        
        let reminders = [reminder1.isOn, reminder2.isOn, reminder3.isOn]
        let remindersAsString = arrayToString(reminders)

        let colour = selectedColour
        
        currentEvent!.name = title
        currentEvent!.emoji = emoji
        currentEvent!.includedTime = includedTime
        currentEvent!.date = date
        currentEvent!.time = time
        currentEvent!.reminders = remindersAsString
        currentEvent!.colour = colour
        
        eventController.updateEvent(currentEvent!)
        firebaseDataController.updateEvent(currentEvent!)
        
        notificationManager.removeNotifications(currentEvent!)
        notificationManager.schedule(currentEvent!)
        
        WidgetCenter.shared.reloadAllTimelines()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func arrayToString(_ array:[Bool]) -> String {
        let stringArray = array.map{String($0)}
        return stringArray.joined(separator: ",")
    }
    
    func stringToArray(_ s:String) -> [Bool] {
        let stringArray:[String] = s.components(separatedBy: ",")
        return stringArray.map{Bool($0)!}
    }
    
    func popAlert(_ alertTitle:String, _ alertMessage:String){
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in }))
        
        self.present(alertView, animated: true, completion: nil)
    }
   
}
