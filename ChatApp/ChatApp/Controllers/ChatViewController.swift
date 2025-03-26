//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Jeanette on 2/8/25.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    /**
     
        Test accounts
            e@example.com
            password1
     
            user@usernames.com
            password
     
            at@dot.com
            password
     */
    
    var messages: [Message] = [
//        Message(sender: "1@2.com", body: "Hey!"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
        tableView.dataSource = self
        title = Constants.appName.rawValue
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: Constants.cellNibName.rawValue, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier.rawValue)
        
        loadMessages()
    }
    
    func loadMessages() {
        
        guard let uid = checkIfUserIsAuthenticated() else { return }
        db.collection(Constants.fStoreCollectionName.rawValue)
//            .whereField(Constants.fStoreSenderField.rawValue, isEqualTo: uid)
            .order(by: Constants.fStoreDateField.rawValue, descending: false)
            .addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("[d] error retrieving data: \(error )")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {
                    return
                }
                self.messages = []
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let messageSender = data[Constants.fStoreSenderField.rawValue] as? String,
                          let messageBody = data[Constants.fStoreBodyField.rawValue] as? String
                    else {
                        print("[d] sender and message may not exist")
                        return
                    }
                    let newMessage = Message(sender: messageSender, body: messageBody)
                    self.messages.append(newMessage)
                    
                    Task {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
                
            }
          
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        guard let messageBody = messageTextfield.text,
              let messageSender = Auth.auth().currentUser?.uid
        else {
            return
        }
        
        let _ = checkIfUserIsAuthenticated()
        db.collection(Constants.fStoreCollectionName.rawValue).addDocument(data:
                                                                            [Constants.fStoreSenderField.rawValue: messageSender,
                                                                             Constants.fStoreBodyField.rawValue: messageBody,
                                                                             Constants.fStoreDateField.rawValue: Date().timeIntervalSince1970
                                                                            ]) { error in
            if let error = error {
                print("[d] error adding document: \(error)")
            }
            print("[d] added-------------------")
            print("[d] sender: \(messageSender)")
            print("[d] body: \(messageBody)")
            
            let newMessage = Message(sender: messageSender, body: messageBody)
            self.messages.append(newMessage)
            
            Task {
                self.messageTextfield.text = ""
                self.tableView.reloadData()
            }
        }
        
        
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier.rawValue, for: indexPath)
            as! MessageCell
        
        cell.label.text = message.body
        
        //message from current user
        if message.sender == Auth.auth().currentUser?.uid {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.userColor.rawValue)
            cell.label.textColor = UIColor(named: Constants.userTextColor.rawValue)
        } else {
            //message from another sender
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.senderColor.rawValue)
            cell.label.textColor = UIColor(named: Constants.senderTextColor.rawValue)
        }
        
        return cell
    }     
}
