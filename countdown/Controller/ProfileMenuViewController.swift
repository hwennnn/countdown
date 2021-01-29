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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if (appDelegate.currentUser != nil){
            self.userID.text = appDelegate.currentUser!.email
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError.localizedDescription)
        }
        
        eventController.deleteAllEvents()
        
        // dismiss the side menu
        self.dismiss(animated: false, completion: nil)
        
        // dismiss the presenting view controller(mainVC)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
