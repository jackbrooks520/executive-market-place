 

import UIKit

class ProfessionalLogInMobNoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gBtnAlreadyProviderLogInTick: UIButton!
    @IBOutlet weak var gTxtFldMobNo: UITextField!
    @IBOutlet weak var gTxtFldMobCode: UITextField!
    @IBOutlet var gBtnMobCode: UIButton!
    @IBOutlet weak var gViewPrevious: UIView!
    @IBOutlet weak var gViewNext: UIView!
    @IBOutlet weak var gBtnPrevious: UIButton!
    @IBOutlet weak var gBtnNext: UIButton!
    @IBOutlet weak var gLblAlreadyContent: UILabel!
    @IBOutlet weak var gViewAlreadyProfessional: UIView!
    @IBOutlet weak var gViewPreviousAndRegisterBtn: UIView!
    @IBOutlet weak var gViewRegisterTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
