//
//  AddChannelVC.swift
//  Smack
//
//  Created by badal shah on 30/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    //Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var txtChannelName: UITextField!
    @IBOutlet weak var txtChannelDescription: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    @IBAction func closeModelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let channelname = txtChannelName.text , txtChannelName.text != "" else { return}
        guard let channelDescription = txtChannelDescription.text else { return }
        SocketService.instance.addChannel(channelName: channelname, channelDescription: channelDescription) { (success) in
            print("Sucessfully Created Channel")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupView(){
        txtChannelName.attributedPlaceholder = NSAttributedString(string: "ChannelName", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
        txtChannelDescription.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedStringKey.foregroundColor:SMACK_PURPLE_PLACEHOLDER])
       
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(recognizer:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc  func closeTap ( recognizer:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}
