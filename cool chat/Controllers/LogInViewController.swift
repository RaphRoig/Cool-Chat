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
        updateUI()
    }
    
    func updateUI() {
        updateTextFields()
    }
    
    func updateTextFields() {
        emailTextField.layer.cornerRadius = 10.0
        passwordTextField.layer.cornerRadius = 10.0
        emailTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FBManager.logUserInAndPerformSegue(withEmail: email, password: password, segueID: K.SegueId.logInToContactList, origin: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.logInToContactList {
            let destinationVC = segue.destination as! ContactListViewController
            destinationVC.userAddress = FBManager.getCurrentUserEmail()!
        }
    }
}
