 

import UIKit
import AARatingBar

class ProvidersTableViewCell: UITableViewCell {

    @IBOutlet weak var gViewRatingBar: AARatingBar!
    @IBOutlet weak var gLblViews: UILabel!
    @IBOutlet weak var gLblUserName: UILabel!
    @IBOutlet weak var gImgViewBullet2: UIImageView!
    @IBOutlet weak var gImgViewBullet1: UIImageView!
    @IBOutlet weak var gImgViewBullet3: UIImageView!
    
    @IBOutlet weak var gLblBullet1: UILabel!
    @IBOutlet weak var gLblBullet2: UILabel!
    @IBOutlet weak var gLblBullet3: UILabel!
    
    @IBOutlet weak var gLblContactNumber: UILabel!
    @IBOutlet weak var gLblPhoneNumberValue: UILabel!
    
    @IBOutlet weak var gmyProfileImg: UIImageView!
    @IBOutlet var gLblProfileUser: UILabel!
    
    @IBOutlet weak var calendarBtnWidth: NSLayoutConstraint!
    
    @IBOutlet weak var gBtnChat: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
