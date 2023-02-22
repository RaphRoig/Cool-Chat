//
//  RegisterViewController.swift
//  cool chat
//
//  Created by Raphaël Roig on 03/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    
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
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FBManager.registerUserAndPerformSegue(withEmail: email, password: password, segueID: K.SegueId.registerToContactList, origin: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.registerToContactList {
            let destinationVC = segue.destination as! ContactListViewController
            destinationVC.userAddress = FBManager.getCurrentUserEmail()!
        }
    }
}
