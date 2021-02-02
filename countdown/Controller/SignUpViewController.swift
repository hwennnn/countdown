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
    
    // Initialisation of storyboard objects
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    // This function will initialise the animation view and delegate when the view is loaded.
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
    
    // play the animation when the view appeared.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // 4. Play animation
        animationView.play()
    }
    
    // pause the animation when the view disappeared.
    override func viewDidDisappear(_ animated: Bool) {
        animationView.pause()
    }
    
    // stop the animation when receiving memory warning.
    override func didReceiveMemoryWarning() {
        animationView.stop()
    }
    
    // pause the animation when the applicaton goes to background.
    @objc func didEnterBackground() {
        print("didEnterBackground")
        animationView.pause()
   }
    
    // playback the animation when the application once becomes active.
    @objc func didBecomeActive() {
        print("didBecomeActive")
        animationView.play()
    }
    
    // tap gesture reconginizer which is binned to the back image view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // Close the keyboard when the view is touched.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // UITextFieldDelegate
    // Enable "next" and "go" when pressing return on the textField
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
    
    // pop the viewController when "back" image view is clicked
    @objc func back(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }

    // regex function to validate the email
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    // regex function to validate the password
    func validatePassword(_ password:String) -> Bool{
        // Minimum 8-17 characters at least 1 Alphabet and 1 Number:
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,17}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // Customisable pop alert function
    func popAlert(_ alertTitle:String, _ alertMessage:String){
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    // Pop success alert function when successfully signed up
    func popSuccess(){
        let alertView = UIAlertController(title: "Successful", message: "Your account has been created", preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in self.navigationController?.popViewController(animated: true) }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    // Sign Up action
    @IBAction func signUp(_ sender: Any) {
        // Animate the activity indicator
        self.activityIndicator.startAnimating()
        // Disable the signup button to prevent multiple submission
        self.signUpButton.isEnabled = false
        
        let email = emailField.text!
        let password = passwordField.text!
        
        let isValidEmail = validateEmail(email)
        let isValidPassword = validatePassword(password)
        
        // validate the email
        if (!isValidEmail){
            self.activityIndicator.stopAnimating()
            popAlert("Invalid email", "Please enter a valid email!")
            self.signUpButton.isEnabled = true
            return
        }
        
        // validate the password
        if (!isValidPassword){
            self.activityIndicator.stopAnimating()
            popAlert("Invalid password", "Please enter a password consisting of 8-17 characters with at least 1 alphabet and 1 number")
            self.signUpButton.isEnabled = true
            return
        }
        
        // Firebase Auth API to validate signup information
        // Redirect the user to login page when success
        // Pop failure alert when got signup error
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
