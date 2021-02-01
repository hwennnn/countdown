//
//  SignUpViewController.swift
//  countdown
//
//  Created by hwen on 27/1/21.
//

import Foundation
import UIKit
import Firebase
import Lottie
import NVActivityIndicatorView

class SignUpViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.contentMode = .scaleAspectFit
        // 2. Set animation loop mode
        animationView.loopMode = .loop
        // 3. Adjust animation speed
        animationView.animationSpeed = 0.5
        // 4. Play animation
        animationView.play()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.back(sender:)))
        self.backButton.isUserInteractionEnabled = true
        self.backButton.addGestureRecognizer(gesture)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.returnKeyType = UIReturnKeyType.next
        passwordField.returnKeyType = UIReturnKeyType.go
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self;
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // 4. Play animation
        animationView.play()
    }
    
    @objc func didEnterBackground() {
        print("didEnterBackground")
        animationView.pause()
   }
    
    @objc func didBecomeActive() {
        print("didBecomeActive")
        animationView.play()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailField){
            passwordField.becomeFirstResponder()
        }
        
        if (textField == passwordField){
            textField.resignFirstResponder()
            signUp(passwordField as Any)
        }
        
        return true
    }
    
    @objc func back(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
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
        self.activityIndicator.startAnimating()
        self.signUpButton.isEnabled = false
        let email = emailField.text!
        let password = passwordField.text!
        
        let isValidEmail = validateEmail(email)
        let isValidPassword = validatePassword(password)
        
        if (!isValidEmail){
            popAlert("Invalid email", "Please enter a valid email!")
            self.signUpButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            return
        }
        
        if (!isValidPassword){
            popAlert("Invalid password", "Please enter a password consisting of 8-17 characters with at least 1 alphabet and 1 number")
            self.signUpButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            self.activityIndicator.stopAnimating()
            if ((error) != nil){
                self.popAlert("Signup Error", error!.localizedDescription)
            }else{
                print("Successful signup for \(email)")
                self.popSuccess()
            }
            self.signUpButton.isEnabled = true
        }
    }
}
