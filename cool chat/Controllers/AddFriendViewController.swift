//
//  AddFriendViewController.swift
//  cool chat
//
//  Created by Raphaël Roig on 04/02/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

    }

    @IBAction func addFriendPressed(_ sender: UIButton) {
        if let email = emailTextField.text, email != "" {
            let collection = db.collection(K.FBase.userFriendsCollection)
            let docForNewFriend = collection.document(email)
            docForNewFriend.getDocument { document1, error1 in
                if let document1 = document1, document1.exists {
                    let doc = collection.document((Auth.auth().currentUser?.email)!)
                    doc.getDocument { docSnapShot, error in
                        if let error {
                            print(error)
                        } else {
                            let data = docSnapShot?.data()!
                            var friendList = data!["friendList"] as! [String]
                            if !friendList.contains(email)  {
                                friendList.append(email)
                                doc.setData([
                                    K.FBase.friendListField: friendList])
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.emailTextField.attributedPlaceholder = NSAttributedString(
                                    string: K.appStrings.alreadyIsFriend,
                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                                self.emailTextField.text = ""
                                
                            }
                            
                        }
                    }
                } else {
                   
                    self.emailTextField.attributedPlaceholder = NSAttributedString(
                        string: K.appStrings.userNotFound,
                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
                    )
                    self.emailTextField.text = ""
                }
            }
            
        } else {
            emailTextField.attributedPlaceholder = NSAttributedString(
                string: K.appStrings.emailMissing,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
            )
        }
    }
}

