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
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.cornerRadius = 15.0
        passwordTextField.layer.cornerRadius = 15.0
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error {
                    print(error)
                } else {
                    self.db.collection(K.FBase.userFriendsCollection).document(email).setData([
                        K.FBase.friendListField: []])
                    self.performSegue(withIdentifier: K.SegueId.registerToContactList, sender: self)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.registerToContactList {
            let destinationVC = segue.destination as! ContactListViewController
            destinationVC.userAddress = (Auth.auth().currentUser?.email)!
        }
    }
    

}
