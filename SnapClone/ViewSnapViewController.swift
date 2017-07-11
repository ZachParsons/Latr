//
//  ViewSnapViewController.swift
//  SnapClone
//
//  Created by Jack Howard on 7/4/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ViewSnapViewController: UIViewController {

    @IBOutlet weak var captionTextField: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var message = Message()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(false, animated: true)
       
        
//         ns current time
        let date = Date()

        let dateFormmater = DateFormatter()
        // 2017-07-09T19:55:41+0000
        // Jul 9 , 2017, 7:55 PM
        
        dateFormmater.dateFormat = "MMM  d, yyyy, h:mm a"

        let nativeGetAtDate = dateFormmater.date(from: message.getAt)
  
        if date > nativeGetAtDate! {
            captionTextField.text = message.descrip
            imageView.sd_setImage(with: URL(string: message.imageURL))
            
            // show nav title
            self.title = "From: \(message.from)"
        } else {
            captionTextField.text = "Sorry you can't read this yet."
        }
    }
    
    @IBAction func tappedShare(_ sender: Any) {
        // share the image view
        let activityVC = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        
        // popover view on the controller
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
    }

    
    
    @IBAction func tappedSave(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    //MARK: - Add image to Library
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your Latr image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    

    
    // to make message disappear
    override func viewWillDisappear(_ animated: Bool) {
        // interpolate the message's uuid url of the photo here to delete that too
        
        // ns current time
        let date = Date()
        let dateFormmater = DateFormatter()
        
        // 2017-07-09T19:55:41+0000
        // Jul 9 , 2017, 7:55 PM
        
        dateFormmater.dateFormat = "MMM  d, yyyy, h:mm a"

        let nativeGetAtDate = dateFormmater.date(from: message.getAt)
 
        if date >= nativeGetAtDate! {
            Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("messages").child(message.key).removeValue()
            Storage.storage().reference().child("images").child("\(message.uuid).jpg").delete { (error) in
                print("we deleted the picture")
            }
        }
        
        super.viewWillDisappear(animated);
        self.navigationController?.setToolbarHidden(true, animated: animated)


    }
    


}


