//
//  SocketService.swift
//  Smack
//
//  Created by badal shah on 30/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit
import SocketIO
class SocketService: NSObject {
    
    static let instance = SocketService()
    
 //
  public  let manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    override init() {
        super.init()
        //let socket = self.manager.defaultSocket

    }
    //NewConnection Established
    func establishConnection() {
        manager.defaultSocket.connect()
    }
    //Close the Conection
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    
    
    
    //Some Being send to webserver via sockets is Called as Emit - Emit can be either the App or API
    //Receive Information is Called as .on
    //For Ex :- When we create channed then Application Emit and Api .On (Receives). viseversa when API send response data the API emits and Application .On. InShort !! Emit = Sender === .On=Receiver
    func addChannel (channelName: String , channelDescription: String , complition: @escaping ComplitionHandler) {
        manager.defaultSocket.emit("newChannel", channelName, channelDescription)
        complition(true)
    }
    
    func getChannel(complition: @escaping ComplitionHandler) {
        manager.defaultSocket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let id = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: id)
            MessageService.instance.channels.append(newChannel)
            complition(true)
        }
    }
    
   // MARK:- Send Message All Functions
    func addMessage(messageBody:String, userId:String, channelId:String, completion: @escaping ComplitionHandler ) {
        let user = UserDataService.instance
        manager.defaultSocket.emit("newMessage", messageBody, userId, channelId, user.name, user.avtarName, user.avtarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        manager.defaultSocket.on("messageCreated") { (dataArry, ack) in
            guard let msgBody = dataArry[0] as? String else {return}
            guard let channelId = dataArry[2] as? String else {return}
            guard let userName = dataArry[3] as? String else {return}
            guard let userAvatar = dataArry[4] as? String else {return}
            guard let userAvatarColor = dataArry[5] as? String else {return}
            guard let id = dataArry[6] as? String else {return}
            guard let timeStamp = dataArry[7] as? String else {return}

            let newMessage = Message(Message: msgBody, userName: userName, channelId: channelId, userAvtar: userAvatar, userAvtarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            
          completion(newMessage)
                
        }
    }
    
    // MARK:- User is Typing (Getting Users who are Typing currently) All Functions
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        manager.defaultSocket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
        }
        
    }

    

}
