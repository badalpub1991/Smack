//
//  BASCustomButton.swift
//  Smack
//
//  Created by badal shah on 26/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit
@IBDesignable
class BASCustomButton: UIButton {
    
    @IBInspectable var cornerRadious : CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadious
        }
    }

   override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadious
    }
   

}
