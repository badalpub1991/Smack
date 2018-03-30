//
//  ChannelVC.swift
//  Smack
//
//  Created by badal shah on 25/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBAction func prepareForUnwindeSegue(Segue : UIStoryboardSegue) {}
    
    //Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        //Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(notif:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        //Get Unread Message
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        }
        
        SocketService.instance.getChannel { (success) in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUserData()
    }

    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }
       
    }
    
    @IBAction func gotoLoginScreen(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
            
        }
    }
    
    @objc func channelsLoaded (_ notif : Notification) {
        tableView.reloadData()
    }
    
  @objc  func userDataDidChange (notif : Notification) {
       setupUserData()
    }
    
    func setupUserData() {
        if AuthService.instance.isLoggedIn {
            btnLogin.setTitle(UserDataService.instance.name, for: .normal)
            imgProfile.image = UIImage(named: UserDataService.instance.avtarName)
            imgProfile.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avtarColor)
        } else {
            btnLogin.setTitle("Login", for: .normal)
            imgProfile.image = UIImage(named : "menuProfileIcon")
            imgProfile.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.id}
        }
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
   // func clearChannels() {
        
}
