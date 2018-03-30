//
//  CreateAccountVC.swift
//  Smack
//
//  Created by badal shah on 25/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    //Outlets
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgUserAvtar: UIImageView!
    @IBOutlet weak var Spinner: UIActivityIndicatorView!
    //Variables
    var avtarName = "Badal A Shah"
    var avtarColor = "[0.5,0.5,0.5,1]"
    var bgColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        Spinner.isHidden = true
        txtUserName.attributedPlaceholder = NSAttributedString(string: "UserName", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDataService.instance.avtarName != "" {
            imgUserAvtar.image = UIImage(named:UserDataService.instance.avtarName)
            avtarName = UserDataService.instance.avtarName
            
            if avtarName.contains("light") && bgColor == nil {
                self.imgUserAvtar.backgroundColor = UIColor.lightGray
            }
        }
    }
    
   

    @IBAction func closeAction(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }

    
    @IBAction func CreateAccountBtnPressed(_ sender: Any) {
        Spinner.isHidden = false
        Spinner.startAnimating()
        guard let email = txtEmail.text , txtEmail.text != "" else {return}
        guard let password = txtPassword.text , txtPassword.text != "" else {return}
         guard let name = txtUserName.text , txtUserName.text != "" else {return}
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avtarName: self.avtarName, avtarColor: self.avtarColor, complition: { (success) in
                            if success {
                                self.Spinner.isHidden = true
                                self.Spinner.stopAnimating()
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func ChooseAvtarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVTAR_PICKER, sender: self)
    }
    
    @IBAction func GenerateBackgroundColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255))/255
        let g = CGFloat(arc4random_uniform(255))/255
        let b = CGFloat(arc4random_uniform(255))/255
        avtarColor = "[\(r),\(g),\(b),1]"
      bgColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        
        UIView.animate(withDuration: 0.2) {
            self.imgUserAvtar.backgroundColor = self.bgColor
        }
        
    }
    
}
