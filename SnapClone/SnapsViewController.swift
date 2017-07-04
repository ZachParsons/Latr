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

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages : [Message] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // find current user's messages
        
        
        // setting up table view
        tableView.dataSource = self
        tableView.delegate = self
        
        
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
            
            
            // kind of like shovelling back into users
            self.messages.append(message)
            
            self.tableView.reloadData()
        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // for returning the one cell of no messages avail
        if messages.count == 0 {
            return 1
        } else {
            return messages.count
        }
        
    }
    
    // prep for view message scene
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        self.performSegue(withIdentifier: "viewSnapSegue", sender: message)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            let nextVC = segue.destination as! ViewSnapViewController
            nextVC.message = sender as! Message
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // for returning the one cell of no messages avail
        if messages.count == 0 {
            cell.textLabel?.text = "You have no Latr messages :("

        } else {
            let message = messages[indexPath.row]
            
            // set cell's text label
            cell.textLabel?.text = message.from
        }
        return cell
    }
    
    
    
    @IBAction func tappedLogout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
