 
import UIKit
import SwiftyCodeView

class ProfessionalLogInOTPCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myBtnResendOtp: UIButton!
    @IBOutlet weak var myLblMobileNumber: UILabel!
    @IBOutlet weak var myViewOtp: SwiftyCodeView!
    @IBOutlet weak var gBtnSubmit: UIButton!
    @IBOutlet weak var gViewNext: UIView!
    @IBOutlet weak var myLblAccessCodeContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
