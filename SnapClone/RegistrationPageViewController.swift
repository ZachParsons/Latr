//
//  RegistrationPageViewController.swift
//  Latr
//
//  Created by Apprentice on 7/8/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit
import Firebase

// need db for specifying the db call
import FirebaseDatabase

class RegistrationPageViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let user =
//        let name = userNameTextField.text;
        let email = userEmailTextField.text;
        let phone = userPhoneTextField.text;
        let password = userPasswordTextField.text;
        let confirmPassword = userConfirmPasswordTextField.text;
        
        // Check for empty fields
        if(email!.isEmpty || password!.isEmpty || confirmPassword!.isEmpty)
        {
            
            // Display alert message 
            displayAlertMessage(userMessage: "Email, Password, & Confirmed Password fields are required.")
            return;
        }
 
        // Check if passwords match
        if(password != confirmPassword)
        {
            // Display alert message
            displayAlertMessage(userMessage: "Passwords do not match.")
            return;
            
        }
        
        // Here is where we need some guidance re saving textfield user inputs
        // Store data, refer to Login for post request to Firebase
        Database.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
        Database.database().reference().child("users").child(user!.uid).child("phone").setValue(user!.phone!)
        Database.database().reference().child("users").child(user!.uid).child("password").setValue(user!.password!)
        
        // Display alert message with confirmation
        var myAlert = UIAlertController(title:"Alert", message:"Registration is successful.", preferredStyle:UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default){
            action in
            self.dismiss(animated: true, completion:nil);
        }
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
        
    }
    
    func displayAlertMessage(userMessage:String)
    {
        var myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
    }
}
