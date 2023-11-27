//
//  LazyLoadingTableViewCell.swift
//  Gigs
//
//  Created by Yosicare on 24/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class LazyLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var gActivityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
