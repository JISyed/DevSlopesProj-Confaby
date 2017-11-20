//
//  AvatarPickerViewController.swift
//  Confaby
//
//  Created by Jibran Syed on 10/9/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class AvatarPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collectionViewAvatarGrid: UICollectionView!
    @IBOutlet weak var segCtrlDarkVsLight: UISegmentedControl!
    
    
    // View starts out with dark avatars
    var avatarType = AvatarType.dark
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.collectionViewAvatarGrid.delegate = self
        self.collectionViewAvatarGrid.dataSource = self
    }
    
    
    // IBAction for a button
    @IBAction func onBackBtnPressed(_ sender: Any) 
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    // IBAction for a segment control
    @IBAction func onDarkVsLightSegCtrlChanged(_ sender: Any) 
    {
        if self.segCtrlDarkVsLight.selectedSegmentIndex == 0    // Dark is selected
        {
            self.avatarType = .dark
        }
        else    // Light is selected
        {
            self.avatarType = .light
        }
        
        
        self.collectionViewAvatarGrid.reloadData()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize 
    {
        var numOfColumns: CGFloat = 3
        
        // Get the width of the current size. 320 is size of iPhone SE (5s)
        if UIScreen.main.bounds.width > 320
        {
            numOfColumns = 4
        }
        
        // Strange math logic needed in order to fit as many icons on the screen as possible
        // On every phone, there will be 4 columns, except iPhone SE (5s)
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        // Remove padding with colViewBoundsWidth-padding
        let cellDimension = ((collectionViewAvatarGrid.bounds.width - padding) - (numOfColumns - 1) * spaceBetweenCells) / numOfColumns
        
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) 
    {
        if self.avatarType == .dark
        {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        }
        else // .light
        {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int 
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int 
    {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell 
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_ID_AVATAR_CELL, for: indexPath) as? AvatarCell
        {
            cell.configureCell(index: indexPath.item, type: self.avatarType)
            return cell
        }
        
        return AvatarCell()
    }
    
    
    
    
    
}
