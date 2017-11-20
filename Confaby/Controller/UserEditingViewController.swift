//
//  UserEditingViewController.swift
//  Confaby
//
//  Created by Jibran Syed on 10/13/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class UserEditingViewController: UIViewController 
{
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var viewBgkTranslucent: UIView!
    @IBOutlet weak var viewColorPreview: UIView!
    
    var currentAvatarColor: String = "[1, 1, 1, 1]"
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupView()
    }
    
    
    @IBAction func onCloseBtnPressed(_ sender: Any) 
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSendBtnPressed(_ sender: Any) 
    {
        guard let newUsername = txtFieldUsername.text, txtFieldUsername.text != "" else {return}
        
        AuthService.instance.updateUsername(id: UserDataService.instance.id, newUsername: newUsername, newAvatarColor: self.currentAvatarColor) { (success) in
            if success
            {
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
            else
            {
                debugPrint("User Rename Failed!")
            }
        }
        
    }
    
    @IBAction func onChangeAvatarColorPressed(_ sender: Any) 
    {
        drand48()   // Helps the randomizer for some reason
        let randomColor = UserDataService.instance.generateRandomColorFromAvatar(avatarName: UserDataService.instance.avatarName)
        var r, g, b, a: CGFloat; r=1; g=1; b=1; a=1
        randomColor.getRed(&r, green: &g, blue: &b, alpha: &a); a = 1
        self.currentAvatarColor = "[\(r), \(g), \(b), \(a)]"
        UIView.animate(withDuration: 0.2)
        {
            self.viewColorPreview.backgroundColor = randomColor
        }
    }
    
    
    
    func setupView()
    {
        // Add tap recognizer for dismissing this modal view by clicking on the translucent area
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(UserEditingViewController.closeModalOnTap(_:)))
        self.viewBgkTranslucent.addGestureRecognizer(closeTouch)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserEditingViewController.closeKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.txtFieldUsername.attributedPlaceholder = NSAttributedString(string: self.txtFieldUsername.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: ConfabyPurplePlaceholder])
        self.txtFieldUsername.text = UserDataService.instance.name
        
        self.currentAvatarColor = UserDataService.instance.avatarColor
        self.viewColorPreview.backgroundColor = UserDataService.instance.parseColor(fromString: self.currentAvatarColor)
        
    }
    
    
    @objc
    func closeModalOnTap(_ recognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc
    func closeKeyboard()
    {
        self.view.endEditing(true)
    }
    

}
