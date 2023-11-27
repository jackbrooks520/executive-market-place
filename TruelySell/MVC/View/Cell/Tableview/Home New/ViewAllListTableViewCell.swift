 

import UIKit
import AARatingBar

class ViewAllListTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblCategory: UILabel!
    @IBOutlet weak var gBtnViewonMap: UIButton!
    @IBOutlet weak var gLblViewonMapContent: UILabel!
    @IBOutlet weak var gContainerViewMap: UIView!
    @IBOutlet weak var gLblListName: UILabel!
    @IBOutlet weak var gRating: AARatingBar!
    @IBOutlet weak var gLblRatingCount: UILabel!
    @IBOutlet weak var gLblBookContent: UILabel!
    @IBOutlet weak var gContainerViewBook: UIView!
    @IBOutlet weak var gLblPrice: UILabel!
    @IBOutlet weak var gImgViewUser: UIImageView!
    @IBOutlet weak var gContianerViewUserImg: UIView!
    @IBOutlet weak var gImgViewList: UIImageView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gConatinerViewListImg: UIView!
    @IBOutlet weak var gImgBookList: UIImageView!
    @IBOutlet weak var gImgLocation: UIImageView!
    @IBOutlet var gBtnFav: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
