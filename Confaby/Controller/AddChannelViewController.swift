//
//  AddChannelViewController.swift
//  Confaby
//
//  Created by Jibran Syed on 10/10/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class AddChannelViewController: UIViewController 
{
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldDescription: UITextField!
    @IBOutlet weak var viewBkgTranslucent: UIView!
    
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupView()
    }

    
    @IBAction func onCloseBtnPressedModal(_ sender: Any) 
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateChannelPressed(_ sender: Any) 
    {
        guard let channelName = txtFieldName.text, txtFieldName.text != "" else {return}
        guard let channelDesc = txtFieldDescription.text else {return}
        
        SocketService.instance.addChannel(name: channelName, description: channelDesc) { (success) in
            if success
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    func setupView()
    {
        // Add tap recognizer for dismissing this modal view by clicking on the translucent area
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelViewController.closeModalOnTap(_:)))
        self.viewBkgTranslucent.addGestureRecognizer(closeTouch)
        
        self.txtFieldName.attributedPlaceholder = NSAttributedString(string: self.txtFieldName.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: ConfabyPurplePlaceholder])
        self.txtFieldDescription.attributedPlaceholder = NSAttributedString(string: self.txtFieldDescription.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: ConfabyPurplePlaceholder])
    }
    
    
    @objc
    func closeModalOnTap(_ recognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
