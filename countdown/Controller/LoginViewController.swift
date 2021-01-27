//
//  LoginViewController.swift
//  countdown
//
//  Created by hwen on 27/1/21.
//

import Foundation
import UIKit
import Firebase

class LoginViewController:UIViewController{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func popAlert(_ alertTitle:String, _ alertMessage:String){
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] success, error in
            guard self != nil else { return }
            if ((success) != nil){
                print("The user has successfully signed in!")
                print(Auth.auth().currentUser?.uid)
            }else{
                print("The email or password is invalid")
                self!.popAlert("Invalid email or password", "Please enter a correct email and password!")
            }
        
        }
    }
}
