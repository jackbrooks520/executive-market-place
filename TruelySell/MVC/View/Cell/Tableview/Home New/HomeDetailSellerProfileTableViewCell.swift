 

import UIKit

class HomeDetailSellerProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var gBtnChat: UIButton!
    @IBOutlet weak var gImgViewChat: UIImageView!
    @IBOutlet weak var gImgViewCall: UIImageView!
    @IBOutlet weak var gViewChatCallWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var gLblName: UILabel!
    @IBOutlet weak var gLblMobNumb: UILabel!
    @IBOutlet weak var gLblEmail: UILabel!
    @IBOutlet weak var gImgViewProfilePic: UIImageView!
    @IBOutlet weak var gViewImage: UIView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gBtnCall: UIButton!
    
    @IBOutlet var gBtnBlock: UIButton!
    
    @IBOutlet var gViewBlock: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
