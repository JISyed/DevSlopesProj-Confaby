//
//  LoginViewController.swift
//  Confaby
//
//  Created by Jibran Syed on 10/7/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController 
{
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupView()
    }
    
    
    @IBAction func onClosePressed(_ sender: Any) 
    {
        // Close this view controller and load the previous one
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateAccountBtnPressed(_ sender: Any) 
    {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func onLoginPressed(_ sender: Any) 
    {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        
        guard  let email = txtFieldEmail.text, txtFieldEmail.text != "" else { return }
        guard  let password = txtFieldPassword.text, txtFieldPassword.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success
            {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
        
        
    }
    
    
    
    func setupView()
    {
        self.spinner.isHidden = true
        
        self.txtFieldEmail.attributedPlaceholder = NSAttributedString(string: self.txtFieldEmail.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: ConfabyPurplePlaceholder])
        self.txtFieldPassword.attributedPlaceholder = NSAttributedString(string: self.txtFieldPassword.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: ConfabyPurplePlaceholder])
    }
    
    
    
    
}
