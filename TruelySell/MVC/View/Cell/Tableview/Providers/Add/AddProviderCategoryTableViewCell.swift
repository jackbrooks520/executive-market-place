 

import UIKit

class AddProviderCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gImgViewIcon: UIImageView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var myBtnCat: UIButton!
    @IBOutlet weak var gViewBtn: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
