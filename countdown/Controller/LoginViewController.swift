//
//  LoginViewController.swift
//  countdown
//
//  Created by hwen on 27/1/21.
//

import Foundation
import UIKit
import Firebase
import WidgetKit
import Lottie
import NVActivityIndicatorView


class LoginViewController: UIViewController, UITextFieldDelegate{
    
    // Initialisation of storyboard objects
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    // Initialisation of controllers
    let firebaseDataController = FirebaseDataController()
    
    // This function will initialise the animation view and delegate when the view is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // redirect to main page if logged in
        if (Auth.auth().currentUser?.uid != nil){
            redirectToMain(false)
        }

        animationView.contentMode = .scaleAspectFit
        // 2. Set animation loop mode
        animationView.loopMode = .loop
        // 3. Adjust animation speed
        animationView.animationSpeed = 0.5
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.returnKeyType = UIReturnKeyType.next
        passwordField.returnKeyType = UIReturnKeyType.go
        
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
    
    // UITextFieldDelegate
    // Enable "next" and "go" when pressing return on the textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == emailField){
            passwordField.becomeFirstResponder()
        }
        
        if (textField == passwordField){
            textField.resignFirstResponder()
            login(passwordField as Any)
        }
        
        return true
    }
    
    // Close the keyboard when the view is touched.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Customisable pop alert function
    func popAlert(_ alertTitle:String, _ alertMessage:String){
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    // This function will present the "main" storyboard when logged in.
    func redirectToMain(_ isAnimated:Bool){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: isAnimated, completion: nil)
    }
    
    // Login Action
    @IBAction func login(_ sender: Any) {
        // Animate the activity indicator
        activityIndicator.startAnimating()
        // Disable the login button to prevent multiple submission
        self.loginButton.isEnabled = false
        
        let email = emailField.text!
        let password = passwordField.text!
        
        // Firebase Auth API to validate login information
        // Redirect the user to main page when success
        // Pop failure alert when got login error
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] success, error in
            guard self != nil else { return }
            if ((success) != nil){
                print("The user has successfully signed in \(email)!")
                
                self!.firebaseDataController.fetchAllEvents(completion: { completion in
                    if (completion){
                        self!.activityIndicator.stopAnimating()
                        self!.redirectToMain(true)
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                })
                
                self!.emailField.text = ""
                self!.passwordField.text = ""
                
            }else{
                self!.activityIndicator.stopAnimating()
                print(error!.localizedDescription)
                self!.popAlert("Login Error", error!.localizedDescription)
            }
            self!.loginButton.isEnabled = true
        }
        
    }
}
