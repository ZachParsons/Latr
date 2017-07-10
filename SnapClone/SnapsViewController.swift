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
            message.uuid = value?["uuid"] as! String
            message.getAt = value?["getAt"] as! String
            
            // take in the message's show critera
//            message.displayable = value?["displayable"] as! String
            
            // that message's unique id
            message.key = snapshot.key
            
            
            // kind of like shovelling back into users
            self.messages.append(message)
            
            self.tableView.reloadData()
        })
        
        
        // wait on observing the child deleted
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("messages").observe(DataEventType.childRemoved, with: {(snapshot) in
            
            // need to make loop for removing programmatically
            var index = 0
            
            // ns current time
            let date = Date()
            let dateFormmater = DateFormatter()
            // month day now
            dateFormmater.dateFormat = "M/d/yy"

            for message in self.messages {
                // can't loop through and call date all of these times
                let nativeGetAtDate = dateFormmater.date(from: message.getAt)
                if message.key == snapshot.key {
                    // make sure unshown db items aren't deleted
                    if date >= nativeGetAtDate! {
                        self.messages.remove(at: index)
                    }
                }
               index += 1
            }
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
//        let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
        // for returning the one cell of no messages avail
        if messages.count == 0 {
            cell.textLabel?.text = "No Latr messages :("
            
            
            // can't click error message cell lol
            cell.isUserInteractionEnabled = false
            cell.detailTextLabel?.text = ""

        } else {
            let message = messages[indexPath.row]
            
            // set cell's text label
            cell.textLabel?.text = message.from
            cell.detailTextLabel!.text = message.getAt
            cell.isUserInteractionEnabled = true
            
            
        }
        return cell
    }
    
    
    
    @IBAction func tappedLogout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
