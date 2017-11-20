//
//  ProfileViewController.swift
//  Confaby
//
//  Created by Jibran Syed on 10/10/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

// This view is modal
class ProfileViewController: UIViewController 
{
    
    @IBOutlet weak var imgProfile: CircleImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewBkgTranslucent: UIView!
    
    
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupView()
        
    }
    
    
    
    @IBAction func onCloseBtnPressedModal(_ sender: Any) 
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLogoutPressed(_ sender: Any) 
    {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditBtnPressed(_ sender: Any) 
    {
        let editUserVC = UserEditingViewController()
        editUserVC.modalPresentationStyle = .custom
        present(editUserVC, animated: true, completion: nil)
    }
    
    
    func setupView() 
    {
        self.setupUserInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        // Add tap recognizer for dismissing this modal view by clicking on the translucent area
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.closeModalOnTap(_:)))
        self.viewBkgTranslucent.addGestureRecognizer(closeTouch)
        
    }
    
    
    func setupUserInfo()
    {
        self.lblUsername.text = UserDataService.instance.name
        self.lblEmail.text = UserDataService.instance.email
        self.imgProfile.image = UIImage(named: UserDataService.instance.avatarName)
        self.imgProfile.backgroundColor = UserDataService.instance.parseColor(fromString: UserDataService.instance.avatarColor)
    }
    
    
    
    @objc
    func closeModalOnTap(_ recognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc
    func userDataDidChange(_ notif: Notification)
    {
        self.setupUserInfo()
    }
    
    
}
