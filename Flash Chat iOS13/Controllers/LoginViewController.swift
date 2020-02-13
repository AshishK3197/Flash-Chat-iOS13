//
//  LoginViewController.swift
//  Flash Chat iOS13
//


import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if  let email = emailTextfield.text , let password = passwordTextfield.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                //[weak self] -> this parameter in closure not required as of now
                //guard let self = self else { return } -> Not required as of now( avoids a retain cycle in cases where we will destroy this current view controller before this closure completes.
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                }
            }
        }
    }
    
}
