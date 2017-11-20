//
//  CreateAccountViewController.swift
//  Confaby
//
//  Created by Jibran Syed on 10/7/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController 
{
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var avatarName = "profileDefault"   // The name of the avatar image file
    var avatarColor = "[0.5, 0.5, 0.5, 1]"  // RBGA
    var bgColor: UIColor?
    
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupView()
    }
    
    
    // This is called everytime a view appears
    override func viewDidAppear(_ animated: Bool) 
    {
        if UserDataService.instance.avatarName != ""
        {
            self.imgUserProfile.image = UIImage(named: UserDataService.instance.avatarName)
            self.avatarName = UserDataService.instance.avatarName
            
            if self.bgColor == nil
            {
                if avatarName.contains("light")
                {
                    self.imgUserProfile.backgroundColor = UIColor.lightGray
                }
                else
                {
                    self.imgUserProfile.backgroundColor = UIColor.white
                }
            }
        }
    }
    
    
    
    @IBAction func onCloseBtnPressed(_ sender: Any) 
    {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    @IBAction func onCreateAccountPressed(_ sender: Any) 
    {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        // Retrieve the email, username, and password from the text field inputs (quit if no input avaliable)
        guard let name = txtFieldUsername.text, txtFieldEmail.text != "" else { return }
        guard let email = txtFieldEmail.text, txtFieldEmail.text != "" else { return }
        guard  let password = txtFieldPassword.text, txtFieldPassword.text != "" else { return }
        
        // Register a new email and password to the chat API server and run the following closure if successful
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success
            {
                // Log in the new user
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success
                    {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            self.spinner.isHidden = true
                            self.spinner.stopAnimating()
                            self.performSegue(withIdentifier: UNWIND, sender: nil)  // Go back to the ChannelMenu View Controller
                            
                            // Send notification that the user has been created
                            NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        })
                    }
                })
            }
        }
        
    }
    
    
    @IBAction func onPickedAvatarPressed(_ sender: Any) 
    {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func onPickBGColorPressed(_ sender: Any) 
    {
        if self.avatarName != "profileDefault"
        {
            self.bgColor = UserDataService.instance.generateRandomColorFromAvatar(avatarName: self.avatarName)
            var r, g, b, a: CGFloat; r=1; g=1; b=1; a=1
            self.bgColor?.getRed(&r, green: &g, blue: &b, alpha: &a); a = 1
            self.avatarColor = "[\(r), \(g), \(b), \(a)]"
            UIView.animate(withDuration: 0.2)
            {
                self.imgUserProfile.backgroundColor = self.bgColor
            }
        }
    }
    
    
    
    
    
    func setupView()
    {
        self.spinner.isHidden = true
        self.txtFieldUsername.attributedPlaceholder = NSAttributedString(string: self.txtFieldUsername.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: ConfabyPurplePlaceholder])
        self.txtFieldEmail.attributedPlaceholder = NSAttributedString(string: self.txtFieldEmail.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: ConfabyPurplePlaceholder])
        self.txtFieldPassword.attributedPlaceholder = NSAttributedString(string: self.txtFieldPassword.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: ConfabyPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    
    @objc 
    func handleTap()
    {
        self.view.endEditing(true)
    }
    
    
    
    
}
