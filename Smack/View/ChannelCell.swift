//
//  ChannelCell.swift
//  Smack
//
//  Created by badal shah on 30/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var lblChannelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }
        else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        let title = channel.channelTitle ?? "" //If title is not Available then it will set BlankString
        self.lblChannelName.text = "#\(title)"
        self.lblChannelName.font = UIFont(name: "HelveticaNeue-Regular", size: 17.0)
        
        for id in MessageService.instance.unreadChannels {
            if id == channel.id {
                self.lblChannelName.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)

            }
        }
    }

}
