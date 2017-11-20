//
//  ChatRoomViewController.swift
//  Confaby
//
//  Created by Jibran Syed on 10/6/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit


// SW Front
class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblChannelName: UILabel!
    @IBOutlet weak var txtFieldMessage: UITextField!
    @IBOutlet weak var tableMessageListing: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblTypingUsers: UILabel!
    
    
    var isTyping = false
    
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatRoomViewController.handleTapGesture))
        view.addGestureRecognizer(tap)
        
        
        self.tableMessageListing.delegate = self
        self.tableMessageListing.dataSource = self
        
        
        tableMessageListing.estimatedRowHeight = 80
        tableMessageListing.rowHeight = UITableViewAutomaticDimension
        
        self.btnSend.isHidden = true
        self.lblTypingUsers.text = ""   // Clear on start
        
        // Add button action form code
        self.btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        // Allow a drag gesture to open the menu VC (tap to undo the drag)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatRoomViewController.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatRoomViewController.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn
            {
                MessageService.instance.messages.append(newMessage)
                self.tableMessageListing.reloadData()
                
                // Scroll to bottom
                if MessageService.instance.messages.count > 0
                {
                    let bottomIndexPath = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableMessageListing.scrollToRow(at: bottomIndexPath, at: .bottom, animated: false)
                }
            }
        }
        
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers
            {
                // We don't want to the app to say that we are typing
                // We also want typing users from the current channel, not all channels
                if typingUser != UserDataService.instance.name && channel == channelId
                {
                    // If no one was typing yet
                    if names == ""
                    {
                        names = typingUser
                    }
                    else // Multiple people typing
                    {
                        // Add new typing user to existing list of typing users
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            // There has to be typers (other than ourselves) AND we must be logged in
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn
            {
                var verb = "is"
                if numberOfTypers > 1
                {
                    verb = "are"
                }
                
                self.lblTypingUsers.text = "\(names) \(verb) typing..."
            }
            else // Either no typers or not logged in
            {
                self.lblTypingUsers.text = ""   // Clear live typing message
            }
            
        }
        
        
        if AuthService.instance.isLoggedIn
        {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
            
            
        }
        
        
        
    }
    
    
    @objc
    func handleTapGesture()
    {
        view.endEditing(true)
    }
    
    
    @objc
    func userDataDidChange(_ notif: Notification)
    {
        if AuthService.instance.isLoggedIn
        {
            self.getMessagesOnLogin()
            self.lblChannelName.text = "Confaby"
        }
        else
        {
            self.lblChannelName.text = "Please Log In"
            self.tableMessageListing.reloadData()
        }
    }
    
    
    @objc
    func channelSelected(_ notif: Notification)
    {
        self.updateWithChannel()
    }
    
    
    
    func getMessagesOnLogin()
    {
        MessageService.instance.findAllChannel { (success) in
            if success
            {
                if MessageService.instance.channels.count > 0
                {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }
                else
                {
                    self.lblChannelName.text = "No Channels Yet"
                }
            }
        }
    }
    
    
    
    func updateWithChannel()
    {
        let channelName = MessageService.instance.selectedChannel?.title ?? "<<Channel Missing>>"
        self.lblChannelName.text = "#\(channelName)"
        self.getMessages()
    }
    
    
    
    func getMessages()
    {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessagesForChannel(id: channelId) { (success) in
            if success
            {
                self.tableMessageListing.reloadData()
            }
        }
        
    }
    
    
    
    @IBAction func onMsgBoxEditing(_ sender: Any) 
    {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        
        if self.txtFieldMessage.text == ""
        {
            self.isTyping = false
            self.btnSend.isHidden = true
            SocketService.instance.declareUserStopsTyping(username: UserDataService.instance.name, channelId: channelId)
        }
        else
        {
            if self.isTyping == false
            {
                btnSend.isHidden = false
                SocketService.instance.declareUserStartsTyping(username: UserDataService.instance.name, channelId: channelId)
            }
            self.isTyping = true
        }
    }
    
    
    @IBAction func onSendBtnPressed(_ sender: Any) 
    {
        if AuthService.instance.isLoggedIn
        {
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let message = txtFieldMessage.text else {return}
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success
                {
                    self.txtFieldMessage.text = ""
                    self.txtFieldMessage.resignFirstResponder()
                    SocketService.instance.declareUserStopsTyping(username: UserDataService.instance.name, channelId: channelId)
                }
            })
        }
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_ID_MESSAGE_CELL, for: indexPath) as? ChatMessageCell
        {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    
    
    
}
