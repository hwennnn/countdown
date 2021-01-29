//
//  EventActionsViewController.swift
//  countdown
//
//  Created by hwen on 29/1/21.
//

import Foundation
import UIKit
import ISEmojiView

class EventActionsViewController: UIViewController, UITextFieldDelegate, EmojiViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var emojiField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var isIncludeTime: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var colour1: UIButton!
    @IBOutlet weak var colour2: UIButton!
    @IBOutlet weak var colour3: UIButton!
    @IBOutlet weak var colour4: UIButton!
    @IBOutlet weak var colour5: UIButton!
    @IBOutlet weak var colour6: UIButton!
    
    var colourList:[UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
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
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        if (isIncludeTime.isOn){
            self.timePicker.isHidden = true
        }else{
            self.timePicker.isHidden = false
        }
        
        colourList = [colour1, colour2, colour3, colour4, colour5, colour6]
        initColourButtons(colourList)
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
        for button in buttons{
            button.layer.cornerRadius = 15
        }
    }
    
    @IBAction func updateIncludeTime(_ sender: Any) {
        if (isIncludeTime.isOn){
            self.timePicker.isHidden = true
        }else{
            self.timePicker.isHidden = false
        }
    }
    
    @IBAction func colourClicked(sender: UIButton){
        for button in colourList{
            if (button.tag == sender.tag){
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
            }else{
                button.layer.borderWidth = 0
                button.layer.borderColor = nil
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
