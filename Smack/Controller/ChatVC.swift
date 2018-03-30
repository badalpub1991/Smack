//
//  ChatVC.swift
//  Smack
//
//  Created by badal shah on 25/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit


class ChatVC: UIViewController, UITableViewDataSource , UITableViewDelegate {
    //Outlet
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var lblNavigationHeader: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblUsersTyping: UILabel!
    
    //Variables
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        btnSend.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tapGesture)
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside )
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(notif:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableview.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let lastIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableview.scrollToRow(at: lastIndex, at: .bottom, animated: false)
                }
            }
        }
        //GetChat Message
        //        SocketService.instance.getChatMessage { (success) in
        //            if success {
        //                self.tableview.reloadData()
        //                if MessageService.instance.messages.count > 0 {
        //                    let lastIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
        //                    self.tableview.scrollToRow(at: lastIndex, at: .bottom, animated: false)
        //                }
        //            }
        //        }
        
        //Get typing Users
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            var names = ""
            var numberOfTypers = 0
            for (typingUser , Channel) in typingUsers {
                if typingUser != UserDataService.instance.name && Channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names),\(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.lblUsersTyping.text = "\(names)\(verb) typing a message"
            } else {
                self.lblUsersTyping.text = ""
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(complition: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
    }
    
    @objc func channelSelected (_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? "" //if Nil then add blank String
        lblNavigationHeader.text = "#\(channelName)"
        getMessages()
    }
    
    @objc  func userDataDidChange (notif : Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessage()
        } else {
            //Please Log In
            lblNavigationHeader.text = "Please Log In"
            tableview.reloadData()
        }
    }
    
    func onLoginGetMessage() {
        MessageService.instance.findAllChannel { (success) in
            //Do Stuff with Channels
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.lblNavigationHeader.text = "No Channels Yet"
                }
            }
        }
    }
    
    func getMessages() {
        guard  let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            self.tableview.reloadData()
        }
    }
    @IBAction func messageBoxEditing(_ sender: Any) {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        if txtMessage.text == "" {
            isTyping = false
            btnSend.isHidden = true
            SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name, channelId)
        } else {
            if isTyping == false {
                btnSend.isHidden = false
                SocketService.instance.manager.defaultSocket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let textMessage = txtMessage.text else {return}
            
            SocketService.instance.addMessage(messageBody: textMessage, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.txtMessage.text = ""
                    self.txtMessage.resignFirstResponder()
                    SocketService.instance.manager.defaultSocket.emit("stopType", UserDataService.instance.name, channelId)
                    //self.tableview.reloadData()
                }
                
            })
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of Row is \(MessageService.instance.messages.count)")
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}

//extension ChatVC: UITableViewDataSource , UITableViewDelegate {
//    
//    
//    
//}

