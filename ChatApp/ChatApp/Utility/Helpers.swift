//
//  Helpers.swift
//  ChatApp
//
//  Created by Jeanette on 2/9/25.
//  


import FirebaseAuth
import FirebaseFirestore

func checkIfUserIsAuthenticated() -> String? {
    if let user = Auth.auth().currentUser {
        print("[d] user is authenticated: \(user.uid)")
        return user.uid
    } else {
        print("[d] user is not authenticated")
    }
    return nil
}
