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
    private static var currentUserEmail = ""
    private init(){}
    
    static func createEmptyContactEmailList(for email: String) {
        db.collection(K.FBase.userContactsCollection).document(email).setData([
            K.FBase.contactEmailListField: []])
    }
    
    static func registerUserAndPerformSegue(withEmail email: String, password: String, segueID: String, origin: UIViewController){
            auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                print(error)
            } else {
                FBManager.createEmptyContactEmailList(for: email)
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
    
    static func getCurrentUserEmail() -> String {
        if currentUserEmail != "" {
            return currentUserEmail
        } else if let email = auth.currentUser?.email {
            self.currentUserEmail = email
            return self.currentUserEmail
        } else {
            print("No user currently connected, don't use this function before a call of logUserInAndPerformSegue or registerUserAndPerformSegue")
            return ""
        }
    }
    
    
    static func loadContactsEmailList(completion: @escaping ([String]?) -> Void){
        let collection = db.collection(K.FBase.userContactsCollection)
        let doc = collection.document(getCurrentUserEmail())
        doc.addSnapshotListener { docSnapShot, error in
            if let error {
                print(error)
                completion(nil)
            } else {
                if let data = docSnapShot?.data(), let contactsEmailList = data[K.FBase.contactEmailListField] as? [String] {
                        completion(contactsEmailList)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    static func loadLastMessageFromContacts(for contactsEmailList: [String], completion: @escaping ([Contact]?) -> Void){
        var contacts = [Contact]()
        let dispatchGroup = DispatchGroup()
        for email in contactsEmailList {
            dispatchGroup.enter()
            let lastMessageQuery = db.collection(K.FBase.messageCollection)
                .whereField(K.FBase.interlocutorsField, in: ["\(email),\(getCurrentUserEmail())","\(getCurrentUserEmail()),\(email)"])
                .order(by: K.FBase.dateField, descending: true)
                .limit(to: 1)
            lastMessageQuery.addSnapshotListener { querySnapshot, error in
                if let error {
                    print(error)
                    completion(nil)
                } else if let lastMessageData = querySnapshot?.documents, lastMessageData.count > 0 {
                        if let lastMessageBody = lastMessageData[0].data()[K.FBase.bodyField] as? String {
                            let contact = Contact(email: email, lastMessage: lastMessageBody)
                            contacts.append(contact)
                        }
                } else {
                    let contact = Contact(email: email, lastMessage: K.appStrings.startConversation + email)
                    contacts.append(contact)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(contacts)
        }
    }
}
