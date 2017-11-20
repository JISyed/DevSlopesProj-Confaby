//
//  ConstantsUtil.swift
//  Confaby
//
//  Created by Jibran Syed on 10/7/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation

// In Swift, every constant here is a global


// A Completion Handler is a closure (lambda) that takes in a Bool and returns nothing
// The underscore tells Swift to omit the argument-label when calling this closure
typealias CompletionHandler = (_ Success: Bool) -> ()


// Web Requests URLs
let BASE_URL = "https://confaby.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)/user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel/"
let URL_UPDATE_USERNAME = "\(BASE_URL)user/"
let URL_UPDATE_MESSAGE = "\(BASE_URL)message/"


// Socket Events
let SOCKET_NEW_CHANNEL = "newChannel"
let SOCKET_CHANNEL_CREATED = "channelCreated"
let SOCKET_NEW_MESSAGE = "newMessage"
let SOCKET_MESSAGE_CREATED = "messageCreated"
let SOCKET_USER_TYPING_UPDATE = "userTypingUpdate"
let SOCKET_START_TYPE = "startType"
let SOCKET_STOP_TYPE = "stopType"


// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"


// iOS User Defaults
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let EMAIL_KEY = "userEmail"



// Table & Collection Cell Reuse Identifiers
let REUSE_ID_MESSAGE_CELL = "messageCell"
let REUSE_ID_CHANNEL_CELL = "channelsCell"
let REUSE_ID_AVATAR_CELL = "avatarGridCell"



// Fonts
let FONT_FAM_HELVETICA_NEUE = "HelveticaNeue"
let FONT_STY_REGULAR = "Regular"
let FONT_STY_BOLD = "Bold"

let FONT_HELV_NEUE_REGU = "\(FONT_FAM_HELVETICA_NEUE)-\(FONT_STY_REGULAR)"
let FONT_HELV_NEUE_BOLD = "\(FONT_FAM_HELVETICA_NEUE)-\(FONT_STY_BOLD)"



// Web Request Headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]



// Colors
let ConfabyPurplePlaceholder = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)



// Notifications Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNELS_SELECTED = Notification.Name("channelSelected")


