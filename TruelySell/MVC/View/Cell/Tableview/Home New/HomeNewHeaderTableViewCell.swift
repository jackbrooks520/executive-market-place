 

import UIKit

class HomeNewHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var gImgViewViewAll: UIImageView!
    @IBOutlet weak var gLblViewAll: UILabel!
    @IBOutlet weak var gViewDesign: UIView!
    @IBOutlet weak var gLblHeader: UILabel!
    @IBOutlet weak var gBtnViewAll: UIButton!
    @IBOutlet weak var gViewAll: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
