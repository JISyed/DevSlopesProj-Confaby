//
//  ChatMessageCell.swift
//  Confaby
//
//  Created by Jibran Syed on 10/12/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell 
{
    @IBOutlet weak var imgUser: CircleImageView!
    @IBOutlet weak var lblUserNname: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var lblMessageBody: UILabel!
    
    
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    
    func configureCell(message: ChatMessage)
    {
        lblMessageBody.text = message.message
        lblUserNname.text = message.userName
        imgUser.image = UIImage(named: message.userAvatar)
        imgUser.backgroundColor = UserDataService.instance.parseColor(fromString: message.userAvatarColor)
        
        // Time stamp is in ISO 8601
        // Year-Month-DayTMilitaryHour:Minute:Second.MillisecondsZ
        
        // Convert to American format
        // AbrevatedMonth Day, Hour:Minute Am/pm
        
        guard let isoDate = message.timeStamp else {return}
        
        let americanDate = UserDataService.instance.iso8601ToAmericanDateTime(fromString: isoDate)
        self.lblTimeStamp.text = americanDate
        
    }
    
    
    

}
