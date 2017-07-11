//
//  User.swift
//  SnapClone
//
//  Created by Jack Howard on 7/4/17.
//  Copyright © 2017 JackHowa. All rights reserved.
//

import Foundation

class User {

//    var uid = ""
//    var email = ""
    
    var email: String!
    var id: String!
    
    init(userEmail: String, userID: String) {
        self.email = userEmail
        self.id = userID
    }
}
