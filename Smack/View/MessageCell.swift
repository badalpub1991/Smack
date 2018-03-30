//
//  MessageCell.swift
//  Smack
//
//  Created by badal shah on 07/01/18.
//  Copyright © 2018 badal shah. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var imgAvtarImageview: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(message: Message) {
        lblMessage.text = message.Message
        lblUsername.text = message.userName
        imgAvtarImageview.image = UIImage(named: message.userAvtar)
        imgAvtarImageview.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvtarColor)
        
        guard let isoDate = message.timeStamp else {return}
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
       let newIsoDate = isoDate.prefix(upTo: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: newIsoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
          let  finalDate = newFormatter.string(from: finalDate)
            lblDateAndTime.text = finalDate
        }
        
    }

   

}
