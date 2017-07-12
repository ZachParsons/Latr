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
import FirebaseAuth

class RegistrationPageViewController: UIViewController {
    
    let databaseRef = Database.database().reference(fromURL:
        "https://snapchat-f15b6.firebaseio.com")
    
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
    
    func displayAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let user = ""
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
        
       // Check email is in email format
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        if(email != emailRegEx)
        {
            self.displayAlertMessage(userMessage: "It appears you haven't entered a invalid email.")
        }
        
        // Check if passwords match
        if(password != confirmPassword)
        {
            // Display alert message
            displayAlertMessage(userMessage: "Passwords do not match.")
            return;
            
        }
        
        //        // Here is where we need some guidance re saving textfield user inputs
        //        // Store data, refer to Login for post request to Firebase
        
        
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            
            
            let userReference =
            self.databaseRef.child("users").child(uid)
            let values = ["email": email, "phone": phone]
            
            userReference.updateChildValues(values
                , withCompletionBlock: { (error, ref) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    self.performSegue(withIdentifier: "registrationSegue", sender: nil)
            })
            
        })
        
        
        
//         Display alert message with confirmation
//        var myAlert = UIAlertController(title:"Alert", message:"Registration is successful.", preferredStyle:UIAlertControllerStyle.alert);
//        
//        let okAction = UIAlertAction(title:"Ok", style: UIAlertActionStyle.default){
//            action in
//            self.dismiss(animated: true, completion:nil);
//        }
//        myAlert.addAction(okAction);
//        self.present(myAlert, animated:true, completion:nil);
    }
    
    
}
