//
//  PictureViewController.swift
//  SnapClone
//
//  Created by Jack Howard on 7/3/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit

// need specific firebase storage
// via https://stackoverflow.com/questions/38561257/swift-use-of-unresolved-identifier-firstorage

import FirebaseStorage

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // need to persist this unique photo id across scenes to delete from db
    var uuid = NSUUID().uuidString
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        nextButton.isEnabled = false
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
        nextButton.isEnabled = true
        
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCamera(_ sender: Any) {
        // for testing we're going to pick one
        imagePicker.sourceType = .savedPhotosAlbum
        // should be camera
        
//        imagePicker.sourceType = .camera
        
        
        // would muck up the ui if allowed editing
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedNext(_ sender: Any) {
        nextButton.isEnabled = false
        
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
                self.performSegue(withIdentifier: "selectUserSegue", sender: metadata?.downloadURL()?.absoluteString)
            }
        })
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // assign destination as the next controller
        let nextVC = segue.destination as! SelectUserViewController
        
        // using the select user vc's var declaration
        // gets sender from sender metadata in perform segue
        nextVC.imageURL = sender as! String
        
        // we know that text here exists with a bang !
        nextVC.descrip = descriptionTextField.text!
        
        // perisist the property of uuid of the created photo to next scene 
        nextVC.uuid = uuid 
    }
}
