//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//


import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
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
        
        titleLabel.text = "⚡️FlashChat"

//        titleLabel.text = ""
//        var charIndex = 0.0
//        let title = "⚡️FlashChat"
//        for item in title{
//            print(charIndex)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 * charIndex) {
//                self.titleLabel.text?.append(item)
//            }
//            charIndex = charIndex + 1
//        }

    }
    

}
