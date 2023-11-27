//
//  LeftMenuTableViewCell.swift
//  PalmOilUser
//
//  Created by user on 13/03/2018.
//  Copyright © 2018 Dreamguys. All rights reserved.
//

import UIKit

class LeftMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var myImgViewMenuImg: UIImageView!
    @IBOutlet weak var myLabelMenuTitle: UILabel!
    @IBOutlet weak var myImgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myImgLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var myLblLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var gViewCount: UIView!
    @IBOutlet weak var gLblCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
