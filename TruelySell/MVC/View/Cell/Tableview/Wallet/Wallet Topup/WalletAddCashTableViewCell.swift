

import UIKit

class WalletAddCashTableViewCell: UITableViewCell {

    @IBOutlet weak var gViewTxtFld: UIView!
    @IBOutlet weak var gBtnOneThousand: UIButton!
    @IBOutlet weak var gBtnTwoThousand: UIButton!
    @IBOutlet weak var gBtnThreeThousand: UIButton!
    @IBOutlet weak var gTxtFldCash: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
