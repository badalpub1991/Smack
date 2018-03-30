//
//  AvtarCell.swift
//  Smack
//
//  Created by badal shah on 28/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit

enum AvtarType {
    case dark
    case light
}
class AvtarCell: UICollectionViewCell {
   
    @IBOutlet weak var avtarImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func setupView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
    func configureCell (index :Int , avtarType : AvtarType) {
        if avtarType == AvtarType.dark {
            avtarImage.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        }else {
            avtarImage.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor

        }
    }
    
}
