//
//  ProfileMenuViewController.swift
//  countdown
//
//  Created by hwen on 27/1/21.
//

import Foundation
import UIKit
import Firebase

class ProfileMenuViewController: UIViewController{
    
    @IBOutlet weak var userID: UILabel!
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    let eventController = EventController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (appDelegate.currentUser != nil){
            self.userID.text = appDelegate.currentUser!.uid
        }
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        eventController.deleteAllEvents()
        
        self.navigationController?.popViewController(animated: false)
        
        let storyboard = UIStoryboard(name: "Base", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginSignupVC") as UIViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
