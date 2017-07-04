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

  
    override func viewDidLoad() {
        super.viewDidLoad()
        // find current user's messages
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("messages").observe(DataEventType.childAdded, with: {(snapshot) in
            // returns object of each user
            // called for each user
            print(snapshot)
            
//            // like calling new
//            let user = User()
//            
//            // setting the values
//            // forcing the value as well as the upcast to a string
//            
//            // need to cast snapshot.value as a NSDictionary.
//            let value = snapshot.value as? NSDictionary
//            
//            user.email = value?["email"] as! String
//            
//            // snapshot dictionary doesn't have a key so can keep this
//            user.uid = snapshot.key // assigns the uid
//            
//            // kind of like shovelling back into users
//            self.users.append(user)
//            
//            self.tableView.reloadData()
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
