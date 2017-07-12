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
    

    @IBOutlet weak var userEmailTextField: UITextField!

    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
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
        registerButton.isEnabled = true 
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        registerButton.isEnabled = false
        
        let user = ""
        //        let name = userNameTextField.text;
        let email = userEmailTextField.text;

        let password = userPasswordTextField.text;
        let confirmPassword = userConfirmPasswordTextField.text;
        
        func isValidEmailAddress(emailAddressString: String) -> Bool {
            var returnValue = true
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
            do {
                let regex = try NSRegularExpression(pattern: emailRegEx)
                let nsString = emailAddressString as NSString
                let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
                if results.count == 0
                {
                    returnValue = false
                }
                
            } catch let error as NSError {
                print("invalid regex: \(error.localizedDescription)")
                returnValue = false
            }
            return returnValue

        }
        
        
        
        // Check for empty fields
        if(email!.isEmpty || password!.isEmpty || confirmPassword!.isEmpty)
        {
            
            // Display alert message
            displayAlertMessage(userMessage: "Email, Password, & Confirmed Password fields are required.")
            return;
        }
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: email!)
        
        if isEmailAddressValid
        {
            print("Email address is valid")
            
        } else {
            print("Email address is not valid")
            displayAlertMessage(userMessage: "Email address is not valid")
        }
        
       // Check email is in email format
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//        if(email != emailRegEx)
//        {
//            displayAlertMessage(userMessage: "You entered an invalid email address.")
//            return;
//        }
        
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
                self.displayAlertMessage(userMessage: "User already exists.")
                
                
                print(error!)
                return;
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            
            let userReference =
            self.databaseRef.child("users").child(uid)
            let values = ["email": email]
            
            userReference.updateChildValues(values
                , withCompletionBlock: { (error, ref) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    self.performSegue(withIdentifier: "registrationSegue", sender: nil)
            })
            
            })
        
        

        
    }
    
    
}
