//
//  AuthService.swift
//  Confaby
//
//  Created by Jibran Syed on 10/8/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService 
{
    //
    // Singleton
    //
    
    static let instance = AuthService()
    private init() {}   // Stop init() from showing up in auto-suggestions
    
    
    //
    // Data
    //
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool
    {
        get
        {
            return self.defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set
        {
            self.defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    
    var authToken: String
    {
        get
        {
            return defaults.value(forKey: TOKEN_KEY) as? String ?? ""
        }
        set
        {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String
    {
        get
        {
            return self.defaults.value(forKey: EMAIL_KEY) as? String ?? ""
        }
        set
        {
            self.defaults.set(newValue, forKey: EMAIL_KEY)
        }
    }
    
    
    
    //
    // Methods
    //
    
    
    
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) 
    {
        let lowerCaseEmail = email.lowercased()
        
        // Make two dicitonaries: the request header and request body
        // HEADER is in constants
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        
        // Send the web request with the new header and body, and run a closure
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil // If the response has no error
            {
                // Calling the escaping closure that was passed in earlier.
                // This will be called when the server sends back a response
                completion(true)
            }
            else
            {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
    
    
    
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler)
    {
        let lowerCaseEmail = email.lowercased()
        
        // Make two dicitonaries: the request header and request body
        // HEADER is in constants
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        
        // Send a login request with the email and password in order to retrieve a auth token for future use in the app
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            if response.result.error == nil // If the response has no error
            {
                // Parsing JSON using SwiftyJSON library
                guard let data = response.data else { return }  // SwiftJSON needs the response data object from Alamofire
                let json = JSON(data: data)
                self.userEmail = json["user"].stringValue // Will be empty string if failed
                self.authToken = json["token"].stringValue
                
                
                self.isLoggedIn = true
                
                // Calling the escaping closure that was passed in earlier.
                // This will be called when the server sends back a response
                completion(true)
            }
            else
            {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler)
    {
        let lowerCaseEmail = email.lowercased()
        
        // Make two dicitonaries: the request header and request body
        // BEARER_HEADER is in constants
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCaseEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        
        // Create a user with given user data, and verify that this data is okay and add it to our UserDataService
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                // SwiftyJSON needs Alamofire's reponse.data
                guard let data = response.data else { return }
                
                // Get response JSON and extract data
                self.setUserInto(data: data)
                
                
                completion(true)
            }
            else
            {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    
    func findUserByEmail(completion: @escaping CompletionHandler) 
    {
        Alamofire.request("\(URL_USER_BY_EMAIL)\(self.userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                // SwiftyJSON needs Alamofire's reponse.data
                guard let data = response.data else { return }
                
                // Get response JSON and extract data
                self.setUserInto(data: data)
                
                
                completion(true)
            }
            else
            {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    func updateUsername(id: String, newUsername: String, newAvatarColor: String, completion: @escaping CompletionHandler)
    {
        let body: [String: Any] = [
            "name": newUsername,
            "email": AuthService.instance.userEmail,
            "avatarName": UserDataService.instance.avatarName,
            "avatarColor": newAvatarColor
        ]
        
        Alamofire.request("\(URL_UPDATE_USERNAME)\(id)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                UserDataService.instance.setUsername(newUsername: newUsername)
                UserDataService.instance.setAvatarColor(newAvatarColor: newAvatarColor)
                /*
                self.updateAllMessagesOfUser(withId: UserDataService.instance.id, newUsername: newUsername, newAvatarColor: newAvatarColor, completion: { (success) in
                    
                })
                */
                
                completion(true)
            }
            else
            {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func updateAllMessagesOfUser(withId userId: String, newUsername: String, newAvatarColor: String, completion: @escaping CompletionHandler)
    {
        for message in MessageService.instance.messages 
        {
            if message.userId == userId
            {
                let body: [String: Any] = [
                    "messageBody": message.message,
                    "userId": message.userId,
                    "channelId": message.channelId,
                    "userName": newUsername,
                    "userAvatar": message.userAvatar,
                    "userAvatarColor": newAvatarColor
                ]
                
                Alamofire.request("\(URL_UPDATE_MESSAGE)\(message.messageId!)", method: .put, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON(completionHandler: { (response) in
                    if response.result.error == nil
                    {
                        completion(true)
                    }
                    else
                    {
                        completion(false)
                        debugPrint(response.result.error as Any)
                    }
                })
            }
        }
    }
    
    
    
    
    func setUserInto(data: Data)
    {
        // Get response JSON and extract data
        let json = JSON(data: data)
        let id = json["_id"].stringValue
        let color = json["avatarColor"].stringValue
        let avatarName = json["avatarName"].stringValue
        let email = json["email"].stringValue
        let name = json["name"].stringValue
        
        
        // Add this user data to local UserDataService
        UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
        
        
        
        
    }
    
    
    
} // end of class

