 

import UIKit

class ProviderDeatilsTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblViews: UILabel!
    @IBOutlet weak var gViewInfo: UIView!
    @IBOutlet weak var gImgViewUser: UIImageView!
    @IBOutlet weak var gLblPhone: UILabel!
    @IBOutlet weak var gLblMail: UILabel!
    @IBOutlet weak var gLblName: UILabel!
    @IBOutlet weak var gViewDescription: UIView!
    @IBOutlet weak var gLblDesc: UILabel!
    @IBOutlet weak var gViewLocationDate: UIView!
    @IBOutlet weak var gLblLocation: UILabel!
    @IBOutlet weak var gBtnShowDirections: UIButton!
    
    @IBOutlet weak var iconPhoneWidth: NSLayoutConstraint!
    @IBOutlet weak var gLblMonday: UILabel!
    @IBOutlet weak var gLblTuesday: UILabel!
    @IBOutlet weak var gLblWed: UILabel!
    @IBOutlet weak var gLblThursday: UILabel!
    @IBOutlet weak var gLblFriday: UILabel!
    @IBOutlet weak var gLblSat: UILabel!
    @IBOutlet weak var gLblSun: UILabel!
    
    @IBOutlet weak var gLblMonVal: UILabel!
    @IBOutlet weak var gLblTuesdayVal: UILabel!
    @IBOutlet weak var gLblWedVal: UILabel!
    @IBOutlet weak var gLblThursVal: UILabel!
    @IBOutlet weak var gLblFriVal: UILabel!
    @IBOutlet weak var gLblSatVal: UILabel!
    @IBOutlet weak var gLblSunVal: UILabel!
    
    @IBOutlet weak var gLblTitleInfo: UILabel!
    
    @IBOutlet var gImgViewMessage: UIImageView!
    @IBOutlet var gImgViewCall: UIImageView!
    @IBOutlet var gImgViewLocation: UIImageView!
    @IBOutlet var gImgViewCalender: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
