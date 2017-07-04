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
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // can also use edited image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // setting the image to the view
        imageView.image = image
        
        imageView.backgroundColor = UIColor.clear
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedCamera(_ sender: Any) {
        // for testing we're going to pick one
        imagePicker.sourceType = .savedPhotosAlbum
        
        // would muck up the ui if allowed editing
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func tappedNext(_ sender: Any) {
        nextButton.isEnabled = false
        
        let imagesFolder = Storage.storage().reference().child("images")
        
        // turns image into data
        // bang to know that image exists
        let imageData = UIImagePNGRepresentation(imageView.image!)!
        
         // upload to firebase
        imagesFolder.child("images.png").putData(imageData, metadata: nil, completion: { (metadata, error) in
            print("we're trying to upload")
            if error != nil {
                print("We had an error: \(String(describing: error))")
            } else {
                // perform segue upon no error next tap upload
                self.performSegue(withIdentifier: "selectUserSegue", sender: nil)
            }
        })
    }
    
   


}
