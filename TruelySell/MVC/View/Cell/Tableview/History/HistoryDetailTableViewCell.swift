
import UIKit

class HistoryDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gViewInfo: UIView!
    @IBOutlet weak var gImgViewUser: UIImageView!
    @IBOutlet weak var gLblPhone: UILabel!
    @IBOutlet weak var gLblMail: UILabel!
    @IBOutlet weak var gLblName: UILabel!
     @IBOutlet weak var gLblTitle: UILabel!
    
    @IBOutlet weak var gViewDescription: UIView!
    @IBOutlet weak var gLblDesc: UILabel!
    
    @IBOutlet weak var gViewLocationDate: UIView!
    @IBOutlet weak var gLblLocation: UILabel!
    @IBOutlet weak var gLblDate: UILabel!
    @IBOutlet weak var gLblTime: UILabel!
    
    @IBOutlet weak var gViewFee: UIView!
    @IBOutlet weak var gLblFee: UILabel!
    
    @IBOutlet weak var gReqImgViewUser: UIImageView!
    @IBOutlet weak var gReqLblPhone: UILabel!
    @IBOutlet weak var gReqLblMail: UILabel!
    @IBOutlet weak var gReqLblName: UILabel!
    
     @IBOutlet weak var gReqLblTitle: UILabel!
    
    @IBOutlet var gImgViewMessage: UIImageView!
    @IBOutlet var gImgViewCall: UIImageView!
    @IBOutlet var gImgViewLocation: UIImageView!
    @IBOutlet var gImgViewCalender: UIImageView!
    @IBOutlet var gImgViewClock: UIImageView!
    @IBOutlet var gImgViewMessageBottom: UIImageView!
    @IBOutlet var gImgViewCallBottom: UIImageView!
    
    @IBOutlet weak var phoneiconWidth: NSLayoutConstraint!
    @IBOutlet weak var emailiconWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
