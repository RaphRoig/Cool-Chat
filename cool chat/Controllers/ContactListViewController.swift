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
    
    
    let db = Firestore.firestore()
    
    var contacts = [Contact]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = K.appStrings.contacts
        navigationItem.hidesBackButton = true
        loadUserContacts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserContacts()
        
    }
    
    @IBAction func addFriendsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.SegueId.contactToAddFriend, sender: self)
    }
    
    func loadUserContacts() {
        FBManager.loadContactsEmailList { contactsEmailList in
            if let contactsEmailList = contactsEmailList {
                FBManager.loadLastMessageFromContacts(for: contactsEmailList) { contacts in
                    if let contacts = contacts {
                        self.contacts = contacts
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("error loading last messages")
                    }
                }
            } else {
                print("error loading friendlist")
            }
        }
    }
    

}

extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        setCellUIParameters(cell: &cell, indexPath: indexPath)
        return cell
    }
    
    func setCellUIParameters(cell: inout UITableViewCell, indexPath: IndexPath) {
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ContactCell")
        cell.textLabel?.text = contacts[indexPath.row].email
        cell.backgroundColor = K.Colors.lightBlue
        cell.detailTextLabel?.numberOfLines = 2
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        cell.detailTextLabel?.text = contacts[indexPath.row].lastMessage
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
    }
}

extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactChosen = contacts[indexPath.row].email
        performSegue(withIdentifier: K.SegueId.contactToConversation, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueId.contactToConversation {
            let destinationVC = segue.destination as! ConversationViewController
            destinationVC.userAddress = userAddress
            destinationVC.contactAddress = contactChosen
        }
    }
}
