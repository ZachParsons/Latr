//
//  SignInViewController.swift
//  SnapClone
//
//  Created by Jack Howard on 7/3/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit
import Firebase

// getting weird errors associated to signIn without specified
// pods from firebase
// via https://stackoverflow.com/questions/37345465/use-of-unresolved-identifier-firauth-swift-2-firebase-3-x

import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // we're logging in and registering now 
    // this will be easier than handling both on different pages
    
    @IBAction func signInTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion:
            // function as a form field for handling responses
            
            { (user, error) in
            print("we tried to sign in")
            if error != nil {
                print("There's an error: \(String(describing: error))")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("we tried to create a user")
                    if error != nil {
                        print("There's an error: \(String(describing: error))")
                    } else {
                        
                    }
                    
                })
            } else {
                print("Signed in successfully")
            }
        }
    )}
}

