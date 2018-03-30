//
//  LoginVC.swift
//  Smack
//
//  Created by badal shah on 25/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupView()
        // Do any additional setup after loading the view.
    }

    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CreateNewAccount(_ sender: Any) {
        
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        self.Spinner.isHidden = false
        self.Spinner.startAnimating()
        guard let email = txtUserName.text , txtUserName.text != "" else {return}
        guard let password = txtPassword.text , txtPassword.text != "" else {return}
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(complition: { (success) in
                    if success {
                       
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.Spinner.stopAnimating()
                        self.Spinner.isHidden = true
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            
        }
    }
    
    func setupView() {
        Spinner.isHidden = true
        txtUserName.attributedPlaceholder = NSAttributedString(string: "UserName", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
}
