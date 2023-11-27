 

import UIKit
import AARatingBar

class HomeDetailOverViewPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblRating: UILabel!
    @IBOutlet weak var gViewRatingBar: AARatingBar!
    @IBOutlet weak var gLblCategory: UILabel!
    @IBOutlet weak var gViewCategory: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
