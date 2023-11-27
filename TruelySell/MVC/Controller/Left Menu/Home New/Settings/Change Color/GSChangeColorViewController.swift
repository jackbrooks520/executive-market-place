//
//  GSChangeColorViewController.swift
//  Gigs
//
//  Created by user on 08/05/20.
//  Copyright © 2020 dreams. All rights reserved.
//

import UIKit
import Presentr

class GSChangeColorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var gViewContainer: UIView!
    @IBOutlet weak var gImgColorPalette: UIImageView!
    @IBOutlet weak var gLblChangeAppTheme: UILabel!
    @IBOutlet weak var gPaletteCollectionView: UICollectionView!
    @IBOutlet weak var gBtnApply: UIButton!
    @IBOutlet weak var myTblView: UITableView!
    
    let myArrColor = APP_PRIMARY_COLOR
    let myArrSecondaryColor = APP_SECONDARY_COLOR
    
    
    var myIntPrimaryIndexpath: Int?
    var myIntSecondaryIndexpath: Int?
    var myIntGradientIndexpath: Int?
    var myStringPrimaryAppColor: String?
    var myStringSecondaryAppColor: String?
    var myStringGradientAppColor1: String?
    var myStringGradientAppColor2: String?
    
    
    let cellGSColorPaletteCollectionViewCellIdentifier = "GSColorPaletteCollectionViewCell"
    let cellColorPaletteTableViewCellIdentifier = "ColorPaletteTableViewCell"
    let cellColorPaletteHeaderTableViewCellIdentifier = "colorPaletteHeaderTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpModel()
        loadModel()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        myTblView.delegate = self
        myTblView.dataSource = self
        gViewContainer.layer.cornerRadius = 10
        gImgColorPalette.image = UIImage(named: "icon_palette")
        gImgColorPalette.image = gImgColorPalette.image?.withRenderingMode(.alwaysTemplate)
        
        gImgColorPalette.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        gLblChangeAppTheme.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        gBtnApply.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        gLblChangeAppTheme.text = SettingsLangContents.CHANGE_COLOR_TITLE.titlecontent()
        gBtnApply.setTitle(CommonTitle.APPLY_BTN.titlecontent(), for: .normal)
        gBtnApply.setTitleColor(UIColor.white, for: .normal)
        myTblView.register(UINib.init(nibName: cellColorPaletteTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: cellColorPaletteTableViewCellIdentifier)
        myTblView.register(UINib.init(nibName: cellColorPaletteHeaderTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: cellColorPaletteHeaderTableViewCellIdentifier)
        
        gBtnApply.layer.cornerRadius = gBtnApply.layer.frame.height / 2
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        // callHomeApi()
        
    }
    
    // MARK: - TableView Delegate and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aCell:colorPaletteHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellColorPaletteHeaderTableViewCellIdentifier) as? colorPaletteHeaderTableViewCell
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell?.gLblHeaderColorPaletteTitle.textAlignment = .right
        }
        else {
            aCell?.gLblHeaderColorPaletteTitle.textAlignment = .left
        }
        if section == 0 {
            aCell!.gLblHeaderColorPaletteTitle.text = SettingsLangContents.PRIMARY_COLOR.titlecontent()
            
        }
        else  {
            aCell!.gLblHeaderColorPaletteTitle.text = SettingsLangContents.SECONDARYCOLOR.titlecontent()
            
        }
        
        return aCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellColorPaletteTableViewCellIdentifier) as! ColorPaletteTableViewCell
        aCell.gCollectionview.delegate = self
        aCell.gCollectionview.dataSource = self
        aCell.gCollectionview.tag = indexPath.section
        aCell.gCollectionview.register(UINib(nibName: cellGSColorPaletteCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellGSColorPaletteCollectionViewCellIdentifier)
        return aCell
    }
    
    // MARK: - CollectionView Delegate and Datasource
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return myArrColor.count
        }
        else  {
            return myArrSecondaryColor.count
        }
        //        return myGradientColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGSColorPaletteCollectionViewCellIdentifier, for: indexPath) as! GSColorPaletteCollectionViewCell
            aCell.gViewPalette.backgroundColor = HELPER.hexStringToUIColor(hex: myArrColor[indexPath.row])
            aCell.gViewPalette.layer.cornerRadius =  aCell.gViewPalette.layer.frame.height / 2
            if indexPath.row == myIntPrimaryIndexpath {
                aCell.gImgTick.isHidden = false
            }
                
            else {
                if myArrColor[indexPath.row] == SESSION.getAppColor() {
                    if myIntPrimaryIndexpath == nil {
                        aCell.gImgTick.isHidden = false
                    }
                    else if indexPath.row != myIntPrimaryIndexpath {
                        aCell.gImgTick.isHidden = true
                    }
                    else {
                        aCell.gImgTick.isHidden = false
                    }
                }
                else {
                    aCell.gImgTick.isHidden = true
                }
            }
            return aCell
        }
        else {
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellGSColorPaletteCollectionViewCellIdentifier, for: indexPath) as! GSColorPaletteCollectionViewCell
            aCell.gViewPalette.backgroundColor = HELPER.hexStringToUIColor(hex: myArrSecondaryColor[indexPath.row])
            aCell.gViewPalette.layer.cornerRadius =  aCell.gViewPalette.layer.frame.height / 2
            if indexPath.row == myIntSecondaryIndexpath {
                aCell.gImgTick.isHidden = false
            }
                
            else {
                if myArrSecondaryColor[indexPath.row] == SESSION.getSecondaryAppColor() {
                    if myIntSecondaryIndexpath == nil {
                        aCell.gImgTick.isHidden = false
                    }
                    else if indexPath.row != myIntSecondaryIndexpath {
                        aCell.gImgTick.isHidden = true
                    }
                    else {
                        aCell.gImgTick.isHidden = false
                    }
                }
                else {
                    aCell.gImgTick.isHidden = true
                }
            }
            return aCell
        }
 
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if collectionView.tag == 0 {
            myIntPrimaryIndexpath = indexPath.row
            myStringPrimaryAppColor = myArrColor[indexPath.row]
        }
        else if collectionView.tag == 1 {
            myIntSecondaryIndexpath = indexPath.row
            myStringSecondaryAppColor = myArrSecondaryColor[indexPath.row]
        }
     
        collectionView.reloadData()
    }
    // MARK: - Button Actions
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        if myStringPrimaryAppColor != nil {
            SESSION.setAppColor(AppColor: myStringPrimaryAppColor!)
            let AppGradientColor1 = HELPER.rgb(fromHex: SESSION.getAppColor()).cgColor
          
            SESSION.setFirstGradientColor(red: Float(AppGradientColor1.components![0]), green: Float(AppGradientColor1.components![1]), blue: Float(AppGradientColor1.components![2]), alpha: Float(AppGradientColor1.components![3]))
        }
        
        if myStringSecondaryAppColor != nil {
            SESSION.setSecondaryAppColor(AppColor: myStringSecondaryAppColor!)
            let AppGradientColor2 = HELPER.rgb(fromHex: SESSION.getSecondaryAppColor()).cgColor
            SESSION.setSecondGradientColor(red: Float(AppGradientColor2.components![0]), green: Float(AppGradientColor2.components![1]), blue: Float(AppGradientColor2.components![2]), alpha: Float(AppGradientColor2.components![3]))
        }
        UITextField.appearance().tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        UITextView.appearance().tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        self.dismiss(animated: true, completion: nil)
        
        APPDELEGATE.loadTabbar()
    }
    
    

    
}
