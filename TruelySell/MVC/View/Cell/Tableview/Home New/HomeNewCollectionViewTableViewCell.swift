 

import UIKit

class HomeNewCollectionViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gCategoryCollectionView: UICollectionView!
    @IBOutlet weak var gLblNoRecordContent: UILabel!
    @IBOutlet var gLblNoRecordVerticalConstraint: NSLayoutConstraint!
    @IBOutlet var gViewEnableLocationContainer: UIView!
    @IBOutlet var gBtnEnableLocation: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
