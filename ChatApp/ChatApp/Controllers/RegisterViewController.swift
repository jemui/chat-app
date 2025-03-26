//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Jeanette on 2/8/25.
//  

import UIKit
import FirebaseAuth
import FirebaseFirestore


class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard
            let email = emailTextfield.text,
            let password = passwordTextfield.text
        else {
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("[d] error creating user \(error)")
                return
            }
            
            guard let authenticatedUser = result?.user else { return }
            let _ = checkIfUserIsAuthenticated()
            let username = email.extractUsername(from: email) ?? "DEFAULT_USERNAME"
            let uid = authenticatedUser.uid
            let user = User(email: email, username: username, uid: uid)
            
            self.saveToFirestore(user: user)
            
            Task {
                self.performSegue(withIdentifier: Constants.register.rawValue, sender: self)
            }
            
        }
    }
    
    func saveToFirestore(user: User) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.setData([
            "email": user.email,
            "username": user.username,
            "createdAt": Timestamp(),
            "uid": user.uid
        ]) { error in
            if let error = error {
                print("[d] error setting user: \(error)")
            }
        }
    }
    
}
