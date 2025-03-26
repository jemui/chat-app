//
//  User.swift
//  ChatApp
//
//  Created by Jeanette on 2/9/25.
//  

import Foundation

struct User {
    
    var email: String
    var username: String
    var uid: String
    
    init(email: String, username: String = "", uid: String = "") {
        self.email = email
        self.username = username
        self.uid = uid
    }
    
    init(user: User) {
        self.email = user.email
        self.username = user.username
        self.uid = user.uid
    }
    
}
