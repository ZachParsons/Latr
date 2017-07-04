//
//  SnapsViewController.swift
//  SnapClone
//
//  Created by Jack Howard on 7/3/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SnapsViewController: UIViewController {
    
    var messages : [Message] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // find current user's messages
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("messages").observe(DataEventType.childAdded, with: {(snapshot) in
            // returns object of each message
            // called for each message
            print(snapshot)
            
            // like calling new
            let message = Message()
            
            // setting the values
            // forcing the value as well as the upcast to a string
            
            // need to cast snapshot.value as a NSDictionary.
            let value = snapshot.value as? NSDictionary
            
            message.imageURL = value?["image_url"] as! String
            message.descrip = value?["description"] as! String
            message.from = value?["from"] as! String
            
            // snapshot dictionary doesn't have a key so can keep this
//            message.uid = snapshot.key // assigns the uid
            
            // kind of like shovelling back into users
            self.messages.append(message)
            
            self.tableView.reloadData()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedLogout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
