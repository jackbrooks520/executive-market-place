//
//  ViewCommentsTableViewCell.swift
//  VRS
//
//  Created by user on 08/03/19.
//  Copyright © 2019 DreamGuys. All rights reserved.
//

import UIKit

class ViewCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var gBtnReply: UIButton!
    @IBOutlet weak var gBtnShowMoreReplies: UIButton!
    @IBOutlet weak var gViewUserImage: UIView!
    @IBOutlet weak var gLblCommentTime: UILabel!
    @IBOutlet weak var gLblUserComments: UILabel!
    @IBOutlet weak var gLblUserName: UILabel!
    @IBOutlet weak var gImgViewUserProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
