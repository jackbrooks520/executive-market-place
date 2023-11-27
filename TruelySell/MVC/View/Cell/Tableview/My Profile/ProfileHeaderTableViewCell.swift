//
//  ProfileHeaderTableViewCell.swift
//  TruelySell
//
//  Created by DreamGuys Tech on 01/02/21.
//  Copyright © 2021 dreams. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet var gLblHeader: UILabel!
    @IBOutlet var gViewSameAsContainer: UIView!
    @IBOutlet var gImgViewCheckbox: UIImageView!
    @IBOutlet var gBtnCheckBox: UIButton!
    @IBOutlet var gBtnTick: UIButton!
    @IBOutlet var gLblSameAsAboveContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
