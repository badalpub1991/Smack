//
//  MessageService.swift
//  Smack
//
//  Created by badal shah on 29/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]() //Array of Channel Object
    var messages = [Message]()
    var unreadChannels = [String]()
    var selectedChannel : Channel?
    
    
    // MARK:- Find All Channel
    func findAllChannel(complition: @escaping ComplitionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                //Swift 4 way in one line
              /*  do {
                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
                    print(self.channels)
                } catch let error {
                    debugPrint(error as Any)
                }*/
                
                //Default Way (Preferable Way)
                do {
                    if let json = try JSON(data:data).array {
                        for item in json {
                            let name = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let id = item["_id"].stringValue
                            let channel = Channel (channelTitle: name, channelDescription: channelDescription, id: id)
                            self.channels.append(channel)
                        }
                       
                    }
                    
                } catch {
                    print(error)
                }
                
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                complition(true)
                
            } else {
                complition(false)
                print(response.result.error as Any)
            }
        }
    }
    
    // MARK:- Find All Messages
    func findAllMessageForChannel(channelId:String, completion: @escaping ComplitionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.cleareMessages()
                do {
                     guard let data = response.data else {return}
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let id = item["_id"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timeStamp = item["timeStamp"].stringValue

                            let message = Message(Message: messageBody, userName: userName, channelId: channelId, userAvtar: userAvatar, userAvtarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                            self.messages.append(message)
                        }
                        completion(true)
                    }
                } catch {
                    print(error)
                }
                
            } else {
                debugPrint(response.error.debugDescription)
                completion(false)
            }
        }
    }
    
    func cleareMessages() {
        messages.removeAll()
    }
    
    
    func removeChannels() {
        self.channels.removeAll()
    }
}
