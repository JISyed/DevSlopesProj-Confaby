//
//  ChannelCell.swift
//  Confaby
//
//  Created by Jibran Syed on 10/10/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell 
{
    @IBOutlet weak var channelName: UILabel!
    
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) 
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected
        {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }
        else
        {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }

    func configureCell(channel: Channel)
    {
        let title = channel.title ?? ""
        self.channelName.text = "#\(title)"
        self.channelName.font = UIFont(name: FONT_HELV_NEUE_REGU, size: 17)
        
        for id in MessageService.instance.unreadChannels
        {
            if id == channel.id
            {
                channelName.font = UIFont(name: FONT_HELV_NEUE_BOLD, size: 22)
            }
        }
        
    }
    
    
    
}
