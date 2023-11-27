//
//  GalleryCollectionViewCell.swift
//  SampleView
//
//  Created by Leo Chelliah on 30/10/19.
//  Copyright © 2019 DreamGuys. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gViewRemoveBtnContainer: UIView!
    @IBOutlet var removeBtn: UIButton!
    @IBOutlet var galleryImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
