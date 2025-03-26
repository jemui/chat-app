//
//  WelcomeViewController.swift
//  ChatApp
//
//  Created by Jeanette on 2/8/25.
//  

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = ""//Constants.appName.rawValue
        
        var charIndex = 0.0
        let titleText = Constants.appName.rawValue
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                Task { @MainActor in
                    self.titleLabel.text?.append(letter)
                }
            }
                
            charIndex += 1.0
        }
    }
    

}
