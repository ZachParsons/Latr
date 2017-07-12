//
//  PictureViewController.swift
//  SnapClone
//
//  Created by Jack Howard on 7/3/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

// need specific firebase storage
// via https://stackoverflow.com/questions/38561257/swift-use-of-unresolved-identifier-firstorage

import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
//    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // need to make a new ib outlet for displayable to be timefield
    
    @IBOutlet weak var datePickerText: UITextField!
    
    // new for adding the email address
    @IBOutlet weak var toTextField: UITextField!
    
    
    
    let datePicker = UIDatePicker()
    
    var getAtTime = ""
    
    // need to persist this unique photo id across scenes to delete from db
    var uuid = NSUUID().uuidString
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        sendButton.isEnabled = false
        createDatePicker()
        
        // don't show toolbar
        self.navigationController?.setToolbarHidden(true, animated: true)

    }
    
    
    
    
    @IBAction func tappedGestureAnywhere(_ sender: Any) {
        descriptionTextField.resignFirstResponder()
        datePickerText.resignFirstResponder()
        
        // update so that to responds as well to tap outside
        toTextField.resignFirstResponder()
    }
    
    func createDatePicker() {
        
        // format picker 
        // for only date
//        datePicker.datePickerMode = .date
        
        // toolbar
        let toolbar = UIToolbar()
        
        // fit to screen
        toolbar.sizeToFit()
        
        // create done button icon
        // action is the function that will be called
        // selector ends the assignment to the textfield
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolbar.setItems([doneButton], animated: true)
        
        datePickerText.inputAccessoryView = toolbar
        
        // assign the datepicker to text field
        datePickerText.inputView = datePicker
        
    }
    
    func donePressed() {
        
        // format 
        // dateformatter object
        let dateFormatter = DateFormatter()
        
        // shortened date show
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .none
        
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        getAtTime = dateFormatter.string(from: datePicker.date)
        
        // assign input text of the returned datePicker var
        datePickerText.text = getAtTime

        // close picker view
        self.view.endEditing(true)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // can also use edited image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // setting the image to the view
        imageView.image = image
        
        imageView.backgroundColor = UIColor.clear
        
        // can now click next button 
        // testing and debugging
        // authorization
        sendButton.isEnabled = true
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCamera(_ sender: Any) {
        // for testing we're going to pick one
//        imagePicker.sourceType = .savedPhotosAlbum
        // should be camera
        
        imagePicker.sourceType = .camera
        
        
        // would muck up the ui if allowed editing
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func tappedLibraryPlus(_ sender: Any) {
        // for testing we're going to pick one
        imagePicker.sourceType = .savedPhotosAlbum
        // should be camera
        
        //        imagePicker.sourceType = .camera
        
        
        // would muck up the ui if allowed editing
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func tappedSend(_ sender: Any) {
        sendButton.isEnabled = false
        
        let imagesFolder = Storage.storage().reference().child("images")
        
        // turns image into data
        // bang to know that image exists
        // higher compression of 0.1 vs a png
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        // upload to firebase
        
        // uu id unique
        imagesFolder.child("\(uuid).jpg").putData(imageData, metadata: nil, completion: { (metadata, error) in
            print("we're trying to upload")
            if error != nil {
                print("We had an error: \(String(describing: error))")
            } else {
                // perform segue upon no error next tap upload
                // absolute designates the value as a string
                
                // loading the message for upload into db
                let message = ["from": Auth.auth().currentUser!.email!, "description": self.descriptionTextField.text!, "image_url": metadata?.downloadURL()?.absoluteString, "uuid": self.uuid, "getAt": self.getAtTime]
                
                
                
                // ok need to find the user based on the email
                let userEmail = self.toTextField.text!
                
                
                
//                
//                var ref: DatabaseReference!
//                ref = Database.database().reference()
//                print(ref.child("users"))
//                
//                ref.child("users").orderByChild("email").equalTo(userEmail)
//                
//                let ref = Database.database().referenceFromURL(ref.child("users")).child("email")
//                let query = ref.queryOrderedByChild("email").queryEqualToValue(userEmail)
//                query.observeEventType(.Value, withBlock: { (snapshot) in
//                    for childSnapshot in snapshot.children {
//                        print(childSnapshot)
//                    }
//                })
                
//                let ref = Database.database().reference().child("users").observe(DataEventType.value, with: {(snapshot) in
//                    print("here")
//                    print(snapshot.childrenCount)
//                })
//                
                
                
//                ref.queryOrdered(byChild: "Des").queryEqual(toValue: "11").observe(.childAdded, with: { snapshot in
//                    if let user = snapshot.value as? [String : AnyObject] {
//                        
//                    }
//                })
//                    print(ref)
            
                
                // need to verify that this email is indeed an email
                // then need to find that uid by the email
                
                
                // lol this would make the db have users/email then their messages info rather than by the uid
                // that could cause problems elsewhere
//                Database.database().reference().child("users").child(userEmail.text!).child("messages").childByAutoId().setValue(message)
                
                
                // child by auto id is a firebase function that prevents reuse of id and makes unique
                // add the message to the set value
                                Database.database().reference().child("users").child(user.uid).child("messages").childByAutoId().setValue(message)
                
                // after selecting a row, go back to the root to see any remaining messages
                // need this pop back after viewing
                self.navigationController!.popToRootViewController(animated: true)
                
                
                
                //                self.performSegue(withIdentifier: "selectUserSegue", sender: metadata?.downloadURL()?.absoluteString)
            }
        })
    }
    
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // assign destination as the next controller
//        let nextVC = segue.destination as! SelectUserViewController
//        
//        // using the select user vc's var declaration
//        // gets sender from sender metadata in perform segue
//        nextVC.imageURL = sender as! String
//        
//        // we know that text here exists with a bang !
//        nextVC.descrip = descriptionTextField.text!
//        
//        // perisist the property of uuid of the created photo to next scene
//        nextVC.uuid = uuid
//        
//        nextVC.getAt = getAtTime
//    }
//    
}
