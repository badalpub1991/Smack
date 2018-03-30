//
//  ProfileVC.swift
//  Smack
//
//  Created by badal shah on 29/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    @IBAction func closeModelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func LogoutButtonPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        self.lblUserName.text = UserDataService.instance.name
        self.lblEmail.text = UserDataService.instance.email
        self.imgProfile.image = UIImage (named : UserDataService.instance.avtarName)
        self.imgProfile.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avtarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(recognizer:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
  @objc  func closeTap ( recognizer:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
