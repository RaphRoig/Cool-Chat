//
//  ConversationViewController.swift
//  cool chat
//
//  Created by Raphaël Roig on 03/02/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class ConversationViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var textFieldViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var userAddress: String = ""
    var contactAddress: String = ""
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.dataSource = self
        messageTextView.delegate = self
        title = contactAddress
        loadMessages()
        messageTextView.clipsToBounds = true
        messageTextView.layer.cornerRadius = 15.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.textFieldViewBottomConstraint.constant = keyboardFrame.size.height - 20
        if messages.count != 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        self.textFieldViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextView.text, messageBody != "" {
            db.collection(K.FBase.messageCollection).addDocument(data: [
                K.FBase.bodyField: messageBody,
                K.FBase.senderField: userAddress,
                K.FBase.receiverField: contactAddress,
                K.FBase.interlocutorsField: "\(contactAddress),\(userAddress)",
                K.FBase.dateField: Timestamp()]) { error in
                    if let error {
                        print(error)
                    } else {
                        DispatchQueue.main.async {
                            self.messageTextView.text = ""
                            self.textViewDidChange(self.messageTextView)
                        }
                    }
                }
        }
    }
    func loadMessages() {
        let conversationQuery = db.collection(K.FBase.messageCollection)
            .whereField(K.FBase.interlocutorsField, in: ["\(contactAddress),\(userAddress)","\(userAddress),\(contactAddress)"])
            .order(by: K.FBase.dateField)
        conversationQuery.addSnapshotListener { querySnapshot, error in
            self.messages = []
            if let error {
                print(error)
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        let data = doc.data()
                        if let sender = data[K.FBase.senderField] as? String, let receiver = data[K.FBase.receiverField] as? String, let body = data[K.FBase.bodyField] as? String, let date = data[K.FBase.dateField] as? Timestamp {
                            let message = Message(sender: sender, receiver: receiver, body: body, date: date.dateValue())
                            self.messages.append(message)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }

}
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        let isUserMessage = messages[indexPath.row].sender == userAddress
        setCellUIParameters(cell, indexPath, isUserMessage)
        return cell
    }
    
    func setCellUIParameters(_ cell: ConversationCell,_ indexPath: IndexPath,_ isUserMessage: Bool) {
        cell.backgroundColor = K.Colors.lightBlue
        cell.selectionStyle = .none
        cell.userMessageLabel.isHidden = isUserMessage ? false : true
        cell.userBackground.isHidden = isUserMessage ? false : true
        cell.receivedMessageLabel.isHidden = isUserMessage ? true : false
        cell.receivedBackground.isHidden = isUserMessage ? true : false
        cell.receivedBackground.layer.cornerRadius = 20.0
        cell.receivedBackground.layer.masksToBounds = true
        cell.userBackground.layer.cornerRadius = 20.0
        cell.userBackground.layer.masksToBounds = true
        cell.userMessageLabel.text = messages[indexPath.row].body
        cell.receivedMessageLabel.text = messages[indexPath.row].body
    }
}

extension ConversationViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        let numberOfLines = CGFloat(Int(textView.contentSize.height)) / (textView.font?.lineHeight ?? 1)
        if numberOfLines >= 5 {
            textView.isScrollEnabled = true
        } else  {
            let fixedWidth = textView.frame.size.width
            let newSize = textView.sizeThatFits(CGSize.init(width: fixedWidth, height: CGFloat(MAXFLOAT)))
            var newFrame = textView.frame
            newFrame.size = CGSize.init(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))), height: newSize.height)
            self.textViewHeight.constant = newSize.height
            self.viewHeight.constant = newSize.height + 35
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
        }
    }
    
}


