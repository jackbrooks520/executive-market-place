 
import UIKit
import AARatingBar

class NewBookingsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gViewServiceTypeName: UILabel!
    @IBOutlet weak var gViewServiceType: UIView!
    @IBOutlet weak var gHeightConstraintUserImg: NSLayoutConstraint!
    @IBOutlet weak var gLblCategory: UILabel!
    @IBOutlet weak var gBtnViewonMap: UIButton!
    @IBOutlet weak var gBtnCall: UIButton!
    @IBOutlet weak var gBtnChat: UIButton!
    @IBOutlet weak var gLblViewonMapContent: UILabel!
    @IBOutlet weak var gContainerViewMap: UIView!
    @IBOutlet weak var gLblListName: UILabel!
    @IBOutlet weak var gRating: AARatingBar!
    @IBOutlet weak var gLblRatingCount: UILabel!
    @IBOutlet weak var gLblPrice: UILabel!
    @IBOutlet weak var gImgViewUser: UIImageView!
    @IBOutlet weak var gContianerViewUserImg: UIView!
    @IBOutlet weak var gImgViewList: UIImageView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gConatinerViewListImg: UIView!
    @IBOutlet var gViewServiceActiveStatus: UIView!
    @IBOutlet var gLblServiceActiveStatus: UILabel!
    @IBOutlet var gBtnServiceActiveStatus: UIButton!
    @IBOutlet var gWidthConstraintServiceActiveStatus: NSLayoutConstraint!
    @IBOutlet weak var gImgMapViewAll: UIImageView!

    @IBOutlet var gCallHeightConstraint: NSLayoutConstraint!
    @IBOutlet var gViewEditLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet var gChatLeadingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
