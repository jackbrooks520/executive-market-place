//
//  PaymentMethodTableViewCell.swift
//  TruelySell
//
//  Created by DreamGuys Tech on 23/03/21.
//  Copyright © 2021 dreams. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet var gViewCodContainer: UIView!
    @IBOutlet var gViewWalletContainer: UIView!
    @IBOutlet var gImgWalletRadio: UIImageView!
    @IBOutlet var gImgCodRadio: UIImageView!
    @IBOutlet var gLblCod: UILabel!
    @IBOutlet var gLblWallet: UILabel!
    @IBOutlet var gBtnWallet: UIButton!
    @IBOutlet var gBtnCod: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
