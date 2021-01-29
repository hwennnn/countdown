//
//  EventActionsViewController.swift
//  countdown
//
//  Created by hwen on 29/1/21.
//

import Foundation
import UIKit
import ISEmojiView

class EventActionsViewController: UIViewController, EmojiViewDelegate{
   
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var emojiField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var isIncludeTime: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialise the emoji keyboard settings
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        emojiField.inputView = emojiView
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        if (isIncludeTime.isOn){
            self.timePicker.isHidden = true
        }else{
            self.timePicker.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    @IBAction func updateIncludeTime(_ sender: Any) {
        if (isIncludeTime.isOn){
            self.timePicker.isHidden = true
        }else{
            self.timePicker.isHidden = false
        }
    }
}
