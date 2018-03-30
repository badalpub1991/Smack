//
//  AvtarPickerVC.swift
//  Smack
//
//  Created by badal shah on 28/12/17.
//  Copyright © 2017 badal shah. All rights reserved.
//

import UIKit

class AvtarPickerVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

{
    
   //Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables
    var avtarType = AvtarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func segmentClicked(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            avtarType = .dark
        } else {
            avtarType = .light
        }
        collectionView.reloadData()
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvtarCell", for: indexPath) as? AvtarCell {
            cell.configureCell(index: indexPath.item, avtarType: avtarType)
            
            return cell
        }
        return AvtarCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numOfColumns : CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numOfColumns = 4
        }
        
        let spaceBetweenCells : CGFloat = 10
        let padding : CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColumns - 1) * spaceBetweenCells) / numOfColumns
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avtarType == .dark {
            UserDataService.instance.setAvtarName(avtarName: "dark\(indexPath.item)")
        }else {
            UserDataService.instance.setAvtarName(avtarName: "light\(indexPath.item)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
