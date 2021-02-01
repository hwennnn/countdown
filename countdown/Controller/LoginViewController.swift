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

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var animationView: AnimationView!
    
    let firebaseDataController = FirebaseDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.contentMode = .scaleAspectFit
        // 2. Set animation loop mode
        animationView.loopMode = .loop
        // 3. Adjust animation speed
        animationView.animationSpeed = 0.5
        
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.returnKeyType = UIReturnKeyType.next
        passwordField.returnKeyType = UIReturnKeyType.go
        
        // redirect to main page if logged in
        if (Auth.auth().currentUser?.uid != nil){
            redirectToMain(false)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // 4. Play animation
        animationView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        animationView.pause()
    }
    
    @objc func didEnterBackground() {
        print("didEnterBackground")
        animationView.pause()
   }
    
    @objc func didBecomeActive() {
        print("didBecomeActive")
        animationView.play()
    }
    
    // UITextFieldDelegate
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func popAlert(_ alertTitle:String, _ alertMessage:String){
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                
        alertView.addAction(UIAlertAction(title: "Noted",style: UIAlertAction.Style.default, handler: { _ in }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func redirectToMain(_ isAnimated:Bool){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: isAnimated, completion: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] success, error in
            guard self != nil else { return }
            if ((success) != nil){
                print("The user has successfully signed in \(email)!")
                self!.emailField.text = ""
                self!.passwordField.text = ""
                
                self!.firebaseDataController.fetchAllEvents()
                self!.redirectToMain(true)
                WidgetCenter.shared.reloadAllTimelines()
            }else{
                print(error!.localizedDescription)
                self!.popAlert("Login Error", error!.localizedDescription)
            }
        
        }
    }
}
