
import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gLblCostInfo: UILabel!
    @IBOutlet weak var gBtnBuyNow: UIButton!
    @IBOutlet weak var currencyInfo: UILabel!
    @IBOutlet weak var subScriptionInfo: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
