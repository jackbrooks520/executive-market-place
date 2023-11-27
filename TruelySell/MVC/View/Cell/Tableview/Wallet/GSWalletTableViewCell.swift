//
//  GSWalletTableViewCell.swift
//  Gigs
//
//  Created by Leo Chelliah on 17/09/19.
//  Copyright © 2019 dreams. All rights reserved.
//

import UIKit

class GSWalletTableViewCell: UITableViewCell {

    @IBOutlet var circleViewBG: UILabel!
    @IBOutlet var outerViewBG: UIView!
    @IBOutlet var transDate: UILabel!
    @IBOutlet var statusLbl: UILabel!
    
    @IBOutlet weak var myLblTransactionAmt: UILabel!
    @IBOutlet weak var myLblReason: UILabel!
    @IBOutlet weak var myLblTotalAmount: UILabel!
    @IBOutlet weak var myLblTaxAmount: UILabel!
    @IBOutlet weak var myImgTransactionIcon: UIImageView!
    @IBOutlet weak var myLblDateCreated: UILabel!
    @IBOutlet weak var myViewCardIcon: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
