//
//  SocketService.swift
//  Confaby
//
//  Created by Jibran Syed on 10/11/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject 
{
    //
    // Singleton
    //
    
    static let instance = SocketService()
    
    // Needed for NSObject subclasses
    override init() 
    {
        super.init()
    }
    
    
    //
    // Data
    //
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    
    
    //
    // Functions
    //
    
    func establishConnection()
    {
        self.socket.connect()
    }
    
    func closeConnection()
    {
        self.socket.disconnect()
    }
    
    func addChannel(name: String, description: String, completion: @escaping CompletionHandler)
    {
        self.socket.emit(SOCKET_NEW_CHANNEL, name, description)
        completion(true)
    }
    
    
    func getChannel(completion: @escaping CompletionHandler)
    {
        self.socket.on(SOCKET_CHANNEL_CREATED) { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {completion(false);return}
            guard let channelDesc = dataArray[1] as? String else {completion(false);return}
            guard let channelID = dataArray[2] as? String else {completion(false);return}
            
            let newChannel = Channel(title: channelName, description: channelDesc, id: channelID)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler)
    {
        let user = UserDataService.instance
        socket.emit(SOCKET_NEW_MESSAGE, messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    
    func getChatMessage(completion: @escaping (_ newMessage: ChatMessage) -> Void )
    {
        socket.on(SOCKET_MESSAGE_CREATED) { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else {return}
            guard let userId = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let messageId = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            
            let newMessage = ChatMessage(message: messageBody, userName: userName, userId: userId, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, messageId: messageId, timeStamp: timeStamp)
            
            completion(newMessage)
            
        }
    }
    
    
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void )
    {
        socket.on(SOCKET_USER_TYPING_UPDATE) { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
        }
    }
    
    
    func declareUserStartsTyping(username: String, channelId: String)
    {
        socket.emit(SOCKET_START_TYPE, username, channelId)
    }
    
    
    func declareUserStopsTyping(username: String, channelId: String)
    {
        socket.emit(SOCKET_STOP_TYPE, username, channelId)
    }
    
    
}
