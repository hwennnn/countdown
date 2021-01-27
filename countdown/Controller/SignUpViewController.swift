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
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func isEmailExist(_ email: String) -> Bool{
        // TODO:check this email does not exist in the database
        return false
    }
    
    func validatePassword(_ password:String) -> Bool{
//        Minimum 8-17 characters at least 1 Alphabet and 1 Number:
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,17}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func popAlert(_ alertTitle:String, _ alertMessage:String){
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in }))
        
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
        
        if (isEmailExist(email)){
            popAlert("Email existed", "Please use another email as this email has been registered with another user!")
        }

        if (!isValidPassword){
            popAlert("Invalid password", "Please enter a password consisting of 8-17 characters with at least 1 alphabet and 1 number")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            print("Successful signup for \(email)")
            
            if ((error) != nil){
                print(error!)
            }
        }

        self.navigationController?.popViewController(animated: true)
    }
    
}