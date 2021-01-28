//
//  SignUpViewController.swift
//  countdown
//
//  Created by hwen on 27/1/21.
//

import Foundation
import UIKit
import Firebase

class SignUpViewController:UIViewController{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func validatePassword(_ password:String) -> Bool{
        // Minimum 8-17 characters at least 1 Alphabet and 1 Number:
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,17}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func popAlert(_ alertTitle:String, _ alertMessage:String){
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func popSuccess(){
        let alertView = UIAlertController(title: "Successful", message: "Your account has been created", preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in self.navigationController?.popViewController(animated: true) }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        
        let isValidEmail = validateEmail(email)
        let isValidPassword = validatePassword(password)
        
        if (!isValidEmail){
            popAlert("Invalid email", "Please enter a valid email!")
            return
        }
        
        if (!isValidPassword){
            popAlert("Invalid password", "Please enter a password consisting of 8-17 characters with at least 1 alphabet and 1 number")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if ((error) != nil){
                self.popAlert("Signup Error", error!.localizedDescription)
            }else{
                print("Successful signup for \(email)")
                self.popSuccess()
            }
        }
    }
    
}
