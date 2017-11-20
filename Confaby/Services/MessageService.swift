//
//  MessageService.swift
//  Confaby
//
//  Created by Jibran Syed on 10/10/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService
{
    static let instance = MessageService()
    private init() {}
    
    
    //
    // Data
    //
    
    var channels = [Channel]()
    var messages = [ChatMessage]()      // Only storing all the messages of 1 channel at a time
    var unreadChannels = [String]()
    var selectedChannel: Channel?
    
    
    
    
    
    //
    // Methods
    //
    
    
    func findAllChannel(completion: @escaping CompletionHandler)
    {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                guard let data = response.data else { return }
                
                if let json = JSON(data: data).array
                {
                    self.channels.removeAll()
                    
                    for item in json
                    {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        
                        let channel = Channel(title: name, description: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
            }
            else
            {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    func clearChannels()
    {
        self.channels.removeAll()
    }
    
    
    
    
    func findAllMessagesForChannel(id: String, completion: @escaping CompletionHandler)
    {
        Alamofire.request("\(URL_GET_MESSAGES)\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                self.clearMessages()
                guard let data = response.data else {return}
                if let json = JSON(data: data).array
                {
                    for item in json
                    {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let messageId = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userId = item["userId"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = ChatMessage(message: messageBody, userName: userName, userId: userId, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, messageId: messageId, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    completion(true)
                }
            }
            else
            {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    
    func clearMessages()
    {
        self.messages.removeAll()
    }
    
    
    
}

