
import UIKit

class WalletTopupCurrentBalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblCurrentBalance: UILabel!
    @IBOutlet weak var gViewWalletView: UIView!
    @IBOutlet weak var gLblWalletBalenceHeading: UILabel!
    @IBOutlet weak var gImgWalletIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
