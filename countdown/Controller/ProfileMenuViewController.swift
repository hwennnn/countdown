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

class ProfileMenuViewController: UIViewController{
    
    @IBOutlet weak var userID: UILabel!
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()
    let notificationManager = LocalNotificationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        if (appDelegate.currentUser != nil){
            self.userID.text = appDelegate.currentUser!.email
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        notificationManager.listScheduledNotifications()
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError.localizedDescription)
        }
        
        eventController.deleteAllEvents()
        notificationManager.removeAllNotifications()
        
        // dismiss the side menu
        self.dismiss(animated: false, completion: nil)
        
        // dismiss the presenting view controller(mainVC)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
