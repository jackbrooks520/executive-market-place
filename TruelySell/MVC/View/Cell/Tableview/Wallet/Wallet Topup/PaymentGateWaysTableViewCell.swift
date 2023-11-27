

import UIKit
import DLRadioButton

class PaymentGateWaysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gBtnPayPal: UIButton!
    @IBOutlet weak var gBtnStripe: UIButton!
    @IBOutlet weak var gLblPayPall: UILabel!
    @IBOutlet weak var gImgPayPallRadioImg: UIImageView!
    @IBOutlet weak var gRadioImgStripe: UIImageView!
    @IBOutlet weak var gLblStripe: UILabel!
    @IBOutlet var gImgRadioRazorPay: UIImageView!
    @IBOutlet var gLblRazorPay: UILabel!
    @IBOutlet var gBtnRazorPay: UIButton!
    @IBOutlet var gViewPayPallContainer: UIView!
    @IBOutlet var gViewStripeContainer: UIView!
    @IBOutlet var gViewRazorPayContainer: UIView!
    @IBOutlet var gPaypallHeightConstraint: NSLayoutConstraint!
    @IBOutlet var gRazorPayHeightConstraint: NSLayoutConstraint!
    @IBOutlet var gLblPayStack: UILabel!
    @IBOutlet var gStripeHeightConstraint: NSLayoutConstraint!
    @IBOutlet var gPayStackHeightConstraint: NSLayoutConstraint!
    @IBOutlet var gViewPayStack: UIView!
    @IBOutlet var gImgRadioPayStack: UIImageView!
    @IBOutlet var gBtnPayStack: UIButton!
    @IBOutlet var gLblPaySolutions: UILabel!
    @IBOutlet var gImgPaysolutions: UIImageView!
    @IBOutlet var gBtnPaySolutions: UIButton!
    
    @IBOutlet var gPaySolutionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet var gViewPaysolutions: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
