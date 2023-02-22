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
        updateUI()
    }
    
    func updateUI() {
        updateButtons()
    }
    
    func updateButtons() {
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
    //call this function in viewDidLoad of view where you need to hide keyboard when the user taps outside
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

// allow to perform action with button (otherwise it just close the keyboard)
extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            return !(touch.view is UIButton)
        }
}
