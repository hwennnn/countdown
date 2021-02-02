//
//  ProfileMenuViewController.swift
//  countdown
//
//  Created by hwen on 27/1/21.
//

import Foundation
import UIKit
import Firebase
import SideMenu
import WidgetKit

class ProfileMenuViewController: UIViewController{
    
    // Initialisation of storyboard objects
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userID: UILabel!
    
    // Initialisation of controllers
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()
    let notificationManager = LocalNotificationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // initialise the view when the view is appearing soon.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailLabel.underline()
        if (appDelegate.currentUser != nil){
            self.userID.text = appDelegate.currentUser!.email
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    // Logout action
    @IBAction func logout(_ sender: Any) {
        // Try signout and throw error when there is one
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError.localizedDescription)
        }
        
        // call controller to delete all events and notifications
        eventController.deleteAllEvents()
        notificationManager.removeAllNotifications()
        
        // reload the widget since data is updated
        WidgetCenter.shared.reloadAllTimelines()
        
        // dismiss the side menu
        self.dismiss(animated: false, completion: nil)
        
        // dismiss the presenting view controller(mainVC)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

// UILabel extension to underline the UILabel text
extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                  value: NSUnderlineStyle.single.rawValue,
              range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
