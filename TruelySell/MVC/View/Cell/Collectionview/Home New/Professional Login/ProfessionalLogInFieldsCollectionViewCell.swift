//
//  ProfessionalLogInFieldsCollectionViewCell.swift
//  SERVPRO
//
//  Created by user on 23/10/19.
//  Copyright © 2019 dreams. All rights reserved.
//

import UIKit

class ProfessionalLogInFieldsCollectionViewCell: UICollectionViewCell {

    @IBOutlet var gConstraintHeightEmail: NSLayoutConstraint!
    @IBOutlet var gConstraintHeightName: NSLayoutConstraint!
    @IBOutlet var gViewMobNo: UIView!
    @IBOutlet var gViewEmail: UIView!
    @IBOutlet var gViewName: UIView!
    @IBOutlet weak var gTxtFldMobCode: UITextField!
    @IBOutlet weak var gTxtFldMobNo: UITextField!
    @IBOutlet weak var gTxtFldEmail: UITextField!
    @IBOutlet weak var gTxtFldName: UITextField!
    @IBOutlet weak var gViewPrevious: UIView!
    @IBOutlet weak var gViewNext: UIView!
    @IBOutlet weak var gBtnPrevious: UIButton!
    @IBOutlet weak var gBtnNext: UIButton!
    @IBOutlet var gBtnMobCode: UIButton!
    @IBOutlet weak var gTxtFldReferenceCode: UITextField!
    @IBOutlet var gViewPasswordContainer: UIView!
    @IBOutlet var gImgPassword: UIImageView!
    @IBOutlet var gTxtFldPassword: UITextField!

    @IBOutlet var gBtnAcceptTerms: UIButton!
    
    @IBOutlet var gBtnReadPrivacy: UIButton!
    
    @IBOutlet var gLblTermsContent: UILabel!
    @IBOutlet var gViewPasswordHeightConstraint: NSLayoutConstraint!
   
    @IBOutlet var gBtnReadTerms: UIButton!
    @IBOutlet var gImgTermsTick: UIImageView!
    @IBOutlet var gBtnAlreadyUser: UIButton!
    @IBOutlet var gLblAlreadyContent: UILabel!
    
    @IBOutlet var gLblAnd: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
