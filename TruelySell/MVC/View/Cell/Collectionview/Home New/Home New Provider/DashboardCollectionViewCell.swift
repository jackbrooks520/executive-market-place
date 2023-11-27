//
//  DashboardCollectionViewCell.swift
//  SampleView
//
//  Created by Leo Chelliah on 30/10/19.
//  Copyright © 2019 DreamGuys. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet var dashBoardTitle: UILabel!
    @IBOutlet var dashBoardImg: UIImageView!
    @IBOutlet var homeView: UIView!
    @IBOutlet var dashboardLblView: UIView!
    @IBOutlet weak var gLblCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
