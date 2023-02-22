//
//  Constants.swift
//  cool chat
//
//  Created by Raphaël Roig on 03/02/2023.
//
import UIKit

struct K {
    
    struct appStrings {
        static let contacts = "Contacts"
        static let startConversation = "Send a message to start a conversation with "
        static let userNotFound = "User doesn't exist!"
        static let emailMissing = "You must type an email!"
        static let alreadyIsFriend = "User already is a friend!"
    }
    
    //Color palette from https://colorhunt.co/palette/ffea208dcbe69df1dfe3f6ff
    struct Colors {
        static let yellow = UIColor(red: 255.0/255, green: 234.0/255, blue: 32.0/255, alpha: 1.0)
        static let blue = UIColor(red: 141.0/255, green: 203.0/255, blue: 230.0/255, alpha: 1.0)
        static let green = UIColor(red: 157.0/255, green: 241.0/255, blue: 223.0/255, alpha: 1.0)
        static let lightBlue = UIColor(red: 227.0/255, green: 246.0/255, blue: 255.0/255, alpha: 1.0)
    }
    
    struct SegueId {
        static let goToRegister = "GoToRegister"
        static let goToLogIn = "GoToLogIn"
        static let registerToContactList = "RegisterToContactList"
        static let logInToContactList = "LogInToContactList"
        static let contactToAddFriend = "ContactToAddFriend"
        static let contactToConversation = "ContactToConversation"
    }
    
    struct FBase{
        static let userContactsCollection = "userContacts"
        static let contactEmailListField = "contactEmailList"
        static let messageCollection = "messages"
        static let senderField = "sender"
        static let receiverField = "receiver"
        static let bodyField = "body"
        static let dateField = "date"
        static let interlocutorsField = "interlocutors"
       
    }
}
