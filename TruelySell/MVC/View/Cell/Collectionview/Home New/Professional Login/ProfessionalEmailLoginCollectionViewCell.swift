

import UIKit

class ProfessionalEmailLoginCollectionViewCell: UICollectionViewCell {

    @IBOutlet var gTxtFldEmail: UITextField!
    
    @IBOutlet var gTxtFldPassword: UITextField!
    
    @IBOutlet var gLblAlreadyProvider: UILabel!
    @IBOutlet var gRadioBtn: UIButton!
   
    @IBOutlet var gViewPrevious: UIView!
    @IBOutlet var gBtnPrevious: UIButton!
    
    @IBOutlet var gViewRadioBtnContainer: UIView!
    @IBOutlet var gBtnForgotPassword: UIButton!
    @IBOutlet var gBtnLogin: UIButton!
    @IBOutlet var gViewLogin: UIView!
    @IBOutlet var gViewRadioBtnHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
