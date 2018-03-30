//
//  GadiantView.swift
//  Smack
//
//  Created by badal shah on 25/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit
@IBDesignable
class GadiantView: UIView {

    @IBInspectable var topColor : UIColor = #colorLiteral(red: 0.3631127477, green: 0.4045833051, blue: 0.8775706887, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1729493737, green: 0.8569635749, blue: 0.8771796823, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
   
    override func layoutSubviews() {
        let gradiantLayer = CAGradientLayer()
        gradiantLayer.colors = [topColor.cgColor , bottomColor.cgColor]
        gradiantLayer.startPoint = CGPoint (x: 0, y: 0)
        gradiantLayer.endPoint = CGPoint (x: 1, y: 1)
        gradiantLayer.frame = self.bounds
        self.layer.insertSublayer(gradiantLayer, at: 0)
        
    }
}




