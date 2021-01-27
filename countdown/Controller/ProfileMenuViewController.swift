//
//  ProfileMenuViewController.swift
//  countdown
//
//  Created by hwen on 27/1/21.
//

import Foundation
import UIKit

class ProfileMenuViewController: UIViewController{
    
    @IBOutlet weak var userID: UILabel!
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userID.text = appDelegate.currentUser!.uid
    }
    
    
    @IBAction func logout(_ sender: Any) {
    }
}
