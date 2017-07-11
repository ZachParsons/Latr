//
//  UserCellTableViewCell.swift
//  Latr
//
//  Created by Zach on 7/11/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var buttonFunc: (() -> (Void))!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        buttonFunc()
    }
    
    func setFunction(_ function: @escaping () -> Void) {
        self.buttonFunc = function
    }
    
}
