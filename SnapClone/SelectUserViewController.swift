//
//  SelectUserViewController.swift
//  SnapClone
//
//  Created by Jack Howard on 7/4/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // using delegate to reference the table view outlet
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }

    // add firebase users 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // calling the cell at the index
        let user = users[indexPath.row]
        
        // assign the label of text 
        cell.textLabel?.text = user.email
        
        return cell
    }
}
