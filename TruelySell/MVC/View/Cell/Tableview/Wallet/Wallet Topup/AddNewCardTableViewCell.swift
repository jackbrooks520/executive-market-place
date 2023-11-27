//
//  AddNewCardTableViewCell.swift
//  Laundry
//
//  Created by Leo Chelliah on 03/11/18.
//  Copyright © 2018 DreamGuys. All rights reserved.
//

import UIKit
//import FormTextField

class AddNewCardTableViewCell: UITableViewCell {
    @IBOutlet weak var gViewContainer: UIView!
    @IBOutlet weak var gViewCardNumberContainer: UIView!
    @IBOutlet weak var gTxtFldCardNumber: FormTextField!
    @IBOutlet weak var gLblCardExpiry: UILabel!
    @IBOutlet weak var gViewCardExpiryContainer: UIView!
    @IBOutlet weak var gTxtFldExpiry: FormTextField!
    @IBOutlet weak var gLblCVV: UILabel!
    @IBOutlet weak var gViewCvvContainer: UIView!
    @IBOutlet weak var gTxtFldCvv: FormTextField!
    @IBOutlet weak var gLblPrivacyMsg: UILabel!
    @IBOutlet weak var gLblDebitCreditCard: UILabel!
    @IBOutlet weak var gViewAddCash: UIView!
    @IBOutlet weak var gBtnAddCash: UIButton!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
