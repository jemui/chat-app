//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Jeanette on 2/8/25.
//  

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard
            let email = emailTextfield.text,
            let password = passwordTextfield.text
        else {
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print("[d] error signing in<##> \(error)")
            }
            
            guard let user = result?.user else {
                print("[d] sign in failed<##>")
                return
            }
            
            print("[d] user signed in succesfully with id:<##> \(user.uid)")
            
            self.performSegue(withIdentifier: Constants.login.rawValue, sender: self)
            
        }
    }
    
}
