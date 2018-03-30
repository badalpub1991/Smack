//
//  CircleImage.swift
//  Smack
//
//  Created by badal shah on 28/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit
@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
          setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
     self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
   
    

}
