//
//  GSLeftMenuTableViewCell.swift
//  Gigs
//
//  Created by dreams on 24/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSLeftMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gImgView: UIImageView!
    @IBOutlet weak var gLblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
