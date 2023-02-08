//
//  ViewController.swift
//  cool chat
//
//  Created by Raphaël Roig on 03/02/2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 20.0
        logInButton.layer.cornerRadius = 20.0
    }


    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender == registerButton {
            performSegue(withIdentifier: K.SegueId.goToRegister, sender: self)
        } else {
            performSegue(withIdentifier: K.SegueId.goToLogIn, sender: self)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            return !(touch.view is UIButton)
        }
}
