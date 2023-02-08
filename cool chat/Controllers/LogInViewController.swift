//
//  LogInViewController.swift
//  cool chat
//
//  Created by Raphaël Roig on 03/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func logInPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { AuthDataResult, error in
                if let error {
                    print(error)
                } else {
                    self.performSegue(withIdentifier: K.SegueId.logInToContactList, sender: self)
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.logInToContactList {
            let destinationVC = segue.destination as! ContactListViewController
            destinationVC.userAddress = (Auth.auth().currentUser?.email)!
        }
    }
}
