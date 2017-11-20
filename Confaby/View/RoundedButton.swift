//
//  RoundedButton.swift
//  Confaby
//
//  Created by Jibran Syed on 10/9/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

// Comment out when you don't want frequent rebuilding
//@IBDesignable
class RoundedButton: UIButton 
{
    @IBInspectable var cornerRadius: CGFloat = 5.0
    {
        didSet
        {
            self.setupView()
        }
    }

    override func awakeFromNib() 
    {
        self.setupView()
    }
    
    
    func setupView()
    {
        self.layer.cornerRadius = self.cornerRadius
    }
    
    
    override func prepareForInterfaceBuilder() 
    {
        super.prepareForInterfaceBuilder()
        
        self.setupView()
    }
    
}
