 
import UIKit

class HomeDetailSellerHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var gContainerViewOnMap: UIView!
    @IBOutlet weak var gLblHeader: UILabel!
    @IBOutlet weak var gBtnViewOnMap: UIButton!
    @IBOutlet weak var gLblViewOnMapContent: UILabel!
    @IBOutlet weak var gViewColor: UIView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gImgMapLocation: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
