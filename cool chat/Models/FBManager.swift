//
//  FBManager.swift
//  cool chat
//
//  Created by Raphaël Roig on 22/02/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FBManager {
    
    private static let db = Firestore.firestore()
    private static let auth = Auth.auth()
    
    private init(){}
    
    static func createEmptyFriendList(for email: String) {
        db.collection(K.FBase.userFriendsCollection).document(email).setData([
            K.FBase.friendListField: []])
    }
    
    static func registerUserAndPerformSegue(withEmail email: String, password: String, segueID: String, origin: UIViewController){
            auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print(error)
            } else {
                FBManager.createEmptyFriendList(for: email)
                origin.performSegue(withIdentifier: segueID, sender: origin)
            }
        }
    }
    
    static func logUserInAndPerformSegue (withEmail email: String, password: String, segueID: String, origin: UIViewController) {
        auth.signIn(withEmail: email, password: password) { AuthDataResult, error in
            if let error {
                print(error)
            } else {
                origin.performSegue(withIdentifier: segueID, sender: origin)
            }
        }
    }
    
    static func getCurrentUserEmail() -> String? {
        return auth.currentUser?.email
    }
}
