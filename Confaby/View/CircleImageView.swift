//
//  CircleImageView.swift
//  Confaby
//
//  Created by Jibran Syed on 10/9/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

//@IBDesignable
class CircleImageView: UIImageView 
{
    
    
    override func awakeFromNib() 
    {
        self.setupView()
    }
    
    
    
    func setupView() 
    {
        // Presuming a square ImageView: taking half the width as the cornerRadius will confine the image into a circle
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    
    override func prepareForInterfaceBuilder() 
    {
        super.prepareForInterfaceBuilder()
        
        self.setupView()
    }
    
}
