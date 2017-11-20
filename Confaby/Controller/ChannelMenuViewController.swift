//
//  ChannelMenuViewController.swift
//  Confaby
//
//  Created by Jibran Syed on 10/6/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

// SW Back
class ChannelMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var imgAvatar: CircleImageView!
    @IBOutlet weak var tableChannels: UITableView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableChannels.delegate = self
        self.tableChannels.dataSource = self
        
        // Change the reveal width of the this back VC (needs SWRevealViewController)
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelMenuViewController.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelMenuViewController.channelsIsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success
            {
                self.tableChannels.reloadData()
            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn
            {
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.tableChannels.reloadData()
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) 
    {
        self.setupUserInfo()
        
        
        
    }
    
    
    
    @IBAction func onAddChannelBtnPressed(_ sender: Any) 
    {
        if AuthService.instance.isLoggedIn
        {
            let addChannelVC = AddChannelViewController()
            addChannelVC.modalPresentationStyle = .custom
            present(addChannelVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onLoginBtnPressed(_ sender: Any) 
    {
        if AuthService.instance.isLoggedIn
        {
            // Show profile page (modally)
            let profile = ProfileViewController()   // Create a new VC if you want to show it modally
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        }
        else    // Not logged in
        {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
        
    }
    
    
    
    @objc
    func userDataDidChange(_ notif: Notification)
    {
        self.setupUserInfo()
    }
    
    
    @objc
    func channelsIsLoaded(_ notif: Notification)
    {
        self.tableChannels.reloadData()
    }
    
    
    
    func setupUserInfo()
    {
        if AuthService.instance.isLoggedIn
        {
            self.btnLogin.setTitle(UserDataService.instance.name, for: .normal)
            self.imgAvatar.image = UIImage(named: UserDataService.instance.avatarName)
            self.imgAvatar.backgroundColor = UserDataService.instance.parseColor(fromString: UserDataService.instance.avatarColor)
        }
        else    // User logging out
        {
            self.btnLogin.setTitle("Login", for: .normal)
            self.imgAvatar.image = UIImage(named: "menuProfileIcon")
            self.imgAvatar.backgroundColor = UIColor.clear
            tableChannels.reloadData()  // Clear channels
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return MessageService.instance.channels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int 
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_ID_CHANNEL_CELL, for: indexPath) as? ChannelCell
        {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) 
    {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        
        if MessageService.instance.unreadChannels.count > 0
        {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter({ (unreadChannel) -> Bool in
                return unreadChannel != channel.id
            })
        }
        let currIndexPath = IndexPath(row: indexPath.row, section: 0)
        self.tableChannels.reloadRows(at: [indexPath], with: .none)
        self.tableChannels.selectRow(at: currIndexPath, animated: false, scrollPosition: .none)
        
        
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        // Go back to ChatVc
        self.revealViewController().revealToggle(animated: true)
    }
    

}
