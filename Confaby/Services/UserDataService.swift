//
//  UserDataService.swift
//  Confaby
//
//  Created by Jibran Syed on 10/9/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation

class UserDataService
{
    // Singleton
    static let instance = UserDataService()
    private init() {}
    
    private(set) public var id = ""
    private(set) public var avatarColor = ""
    private(set) public var avatarName = ""
    private(set) public var email = ""
    private(set) public var name = ""
    
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String)
    {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    
    func setAvatarName(avatarName: String)
    {
        self.avatarName = avatarName
    }
    
    
    func setUsername(newUsername: String)
    {
        self.name = newUsername
    }
    
    func setAvatarColor(newAvatarColor: String)
    {
        self.avatarColor = newAvatarColor
    }
    
    
    func parseColor(fromString: String) -> UIColor 
    {
        let scannerForColor = Scanner(string: fromString)
        let skippedChars = CharacterSet(charactersIn: "[], ")
        let seperatingChar = CharacterSet(charactersIn: ",")
        scannerForColor.charactersToBeSkipped = skippedChars
        
        var r, g, b, a : NSString?
        
        scannerForColor.scanUpToCharacters(from: seperatingChar, into: &r)
        scannerForColor.scanUpToCharacters(from: seperatingChar, into: &g)
        scannerForColor.scanUpToCharacters(from: seperatingChar, into: &b)
        scannerForColor.scanUpToCharacters(from: seperatingChar, into: &a)
        
        let defaultColor = UIColor.lightGray    // If parsing failed
        
        // Unwrap the parsed strings from the scanner into NSStrings
        guard let rValStr = r else { return defaultColor }
        guard let gValStr = g else { return defaultColor }
        guard let bValStr = b else { return defaultColor }
        guard let aValStr = a else { return defaultColor }
        
        
        // Convert the color value strings into CGFloats (convert to Doubles first)
        let red = CGFloat(rValStr.doubleValue)
        let green = CGFloat(gValStr.doubleValue)
        let blue = CGFloat(bValStr.doubleValue)
        let alpha = CGFloat(aValStr.doubleValue)
        
        
        // Return new color
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    func iso8601ToAmericanDateTime(fromString: String) -> String
    {
        // Time stamp is in ISO 8601
        // Year-Month-DayTMilitaryHour:Minute:Second.MillisecondsZ
        
        // 2017-07-13T21:49:25.590Z
        
        let end = fromString.index(fromString.endIndex, offsetBy: -6) // Go back 6 chars from end of string
        // 2017-07-13T21:49:2^5.590Z
        let modString = String(fromString[...end])
        // 2017-07-13T21:49:25
        
        let isoFormatter = ISO8601DateFormatter()
        let isoDateOpt = isoFormatter.date(from: modString.appending("Z"))
        // 2017-07-13T21:49:25Z
        
        let readableFormatter = DateFormatter()
        readableFormatter.dateFormat = "MMM d, h:mm a"  // AbrevatedMonth Day, Hour:Minute Am/pm
        
        if let isoDate = isoDateOpt
        {
            let americanDate = readableFormatter.string(from: isoDate)
            return americanDate
        }
        
        return "<<Invalid Time Stamp Format>>"
    }
    
    
    func generateRandomColorFromAvatar(avatarName: String) -> UIColor
    {
        var r = CGFloat(drand48())  // drand48() returns a Double between 0.0 and 1.0
        var g = CGFloat(drand48())
        var b = CGFloat(drand48())
        
        if avatarName.contains("light")
        {
            // Generate a color value between 0.0 and 0.7
            r = r * 0.9 + 0.0
            g = g * 0.9 + 0.0
            b = b * 0.9 + 0.0
        }
        else    // contains "dark"
        {
            // Generate a color value between 0.4 and 1.0
            r = r * 0.6 + 0.4
            g = g * 0.6 + 0.4
            b = b * 0.6 + 0.4
        }
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    
    
    func logoutUser() 
    {
        self.id = ""
        self.avatarName = ""
        self.avatarColor = ""
        self.email = ""
        self.name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
    
    
    
}
