//
//  GradientView.swift
//  Confaby
//
//  Created by Jibran Syed on 10/7/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

// Uncomment when you want to test the gradient effects in IB
// Causing Xcode to constantly rebuild project!
//@IBDesignable
class GradientView: UIView
{
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1) 
    {
        // Call after setting topColor property
        didSet
        {
            // Update the view rendering
            self.setNeedsLayout()
        }
    }
    
    
    @IBInspectable var bottonColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.8066677517, blue: 0.8470588235, alpha: 1)
    {
        didSet
        {
            self.setNeedsLayout()
        }
    }
    
    
    // Called after setNeedsLayout() is called
    override func layoutSubviews() 
    {
        // Create a gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottonColor.cgColor]
        
        // Gradients layers are 2D gradients using a normalized coordinate system (similar to UVs)
        // X goes right, and Y goes down
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // Set size of gradient (same as size of this view)
        gradientLayer.frame = self.bounds
        
        // Insert this gradient layer as the top layer (0) of this view
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    

}
