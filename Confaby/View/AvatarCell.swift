//
//  AvatarCell.swift
//  Confaby
//
//  Created by Jibran Syed on 10/9/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit


enum AvatarType 
{
    case dark
    case light
}


class AvatarCell: UICollectionViewCell 
{
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    
    func configureCell(index: Int, type: AvatarType)
    {
        if type == AvatarType.dark
        {
            self.imgAvatar.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        else // .light
        {
            self.imgAvatar.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
    }
    
    
    
    func setupView() 
    {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
