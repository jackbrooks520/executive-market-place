
import UIKit

class WalletBalanceTableViewCell: UITableViewCell {
    @IBOutlet var addBtnViewBG: UIView!
    @IBOutlet var walletIconViewBG: UIView!
    @IBOutlet var walletSubViewBG: UIView!
    @IBOutlet var amountAddBtn: UIButton!
    @IBOutlet var walletBalanceViewBG: UIView!
    @IBOutlet weak var myLblWalletBalance: UILabel!
    
    @IBOutlet weak var myBtnWithDrawFund: UIButton!
    @IBOutlet weak var myViewWithDrawFund: UIView!
    @IBOutlet weak var myViewBottomSpaceNSLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var topBarViewBG: UIView!
    @IBOutlet weak var gLblTitleWalletBalance: UILabel!
    
    @IBOutlet weak var gLblTitleWithdrawFund: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
