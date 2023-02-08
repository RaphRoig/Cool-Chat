//
//  ContactListViewController.swift
//  cool chat
//
//  Created by Raphaël Roig on 04/02/2023.
//


import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseSharedSwift

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactChosen: String = ""
    var userAddress: String = ""
    var lastMessages: [String: String] = [String: String]()
    
    let db = Firestore.firestore()
    
    var friendList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = K.appStrings.contacts
        navigationItem.hidesBackButton = true
        loadContactList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadContactList()
        
    }
    
    @IBAction func addFriendsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.SegueId.contactToAddFriend, sender: self)
    }
    
    func loadContactList() {
        let collection = db.collection(K.FBase.userFriendsCollection)
        let doc = collection.document(userAddress)
        doc.addSnapshotListener { docSnapShot, error in
            if let error {
                print(error)
            } else {
                if let data = docSnapShot?.data() {
                    if let fl = data["friendList"] as? [String] {
                        self.friendList = fl
                        self.loadLastMessages()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func loadLastMessages()  {
        for friend in friendList {
            let conversationQuery = db.collection(K.FBase.messageCollection)
                .whereField(K.FBase.interlocutorsField, in: ["\(friend),\(userAddress)","\(userAddress),\(friend)"])
                .order(by: K.FBase.dateField, descending: true)
                .limit(to: 1)
            conversationQuery.addSnapshotListener { querySnapshot, error in
                if let error {
                    print(error)
                } else {
                    if let data = querySnapshot?.documents, data.count > 0 {
                        if let message = data[0].data()[K.FBase.bodyField] as? String {
                            self.lastMessages[friend] = message
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } else {
                        self.lastMessages[friend] = K.appStrings.startConversation + friend
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        setCellUIParameters(cell: &cell, indexPath: indexPath)
        return cell
    }
    
    func setCellUIParameters(cell: inout UITableViewCell, indexPath: IndexPath) {
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ContactCell")
        cell.textLabel?.text = friendList[indexPath.row]
        cell.backgroundColor = K.Colors.lightBlue
        cell.detailTextLabel?.numberOfLines = 2
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        cell.detailTextLabel?.text = lastMessages[friendList[indexPath.row], default: ""]
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
    }
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactChosen = friendList[indexPath.row]
        performSegue(withIdentifier: K.SegueId.contactToConversation, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.contactToConversation {
            let destinationVC = segue.destination as! ConversationViewController
            destinationVC.userAddress = (Auth.auth().currentUser?.email)!
            destinationVC.contactAddress = contactChosen
        }
    }
}
