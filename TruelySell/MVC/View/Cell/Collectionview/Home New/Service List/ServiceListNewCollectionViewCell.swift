
import UIKit
import AARatingBar

class ServiceListNewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gViewRatingBar: AARatingBar!
    @IBOutlet weak var gLblCategoryName: UILabel!
    @IBOutlet weak var gContainerViewCategory: UIView!
    @IBOutlet weak var gLblPrice: UILabel!
    @IBOutlet weak var gLblServiceName: UILabel!
    @IBOutlet weak var gLblRateCount: UILabel!
//    @IBOutlet weak var gViewColor: UIView!
    @IBOutlet weak var gContainerViewBottom: UIView!
    @IBOutlet weak var gImgViewUserImage: UIImageView!
    @IBOutlet weak var gContainerViewUserImage: UIView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gImgViewServiceList: UIImageView!
    @IBOutlet var gBtnFav: UIButton!
    @IBOutlet var gViewDistance: UIView!
    @IBOutlet var gLblDistance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
