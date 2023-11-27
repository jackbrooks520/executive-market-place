 
import UIKit

class ProviderHistoryDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gLblTime: UILabel!
    @IBOutlet weak var gLblDate: UILabel!
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
    @IBOutlet weak var gLblTitleInfo: UILabel!
    @IBOutlet weak var iconPhoneWidth: NSLayoutConstraint!
    @IBOutlet var gImgViewMessage: UIImageView!
    @IBOutlet var gImgViewCall: UIImageView!
    @IBOutlet var gImgViewLocation: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
