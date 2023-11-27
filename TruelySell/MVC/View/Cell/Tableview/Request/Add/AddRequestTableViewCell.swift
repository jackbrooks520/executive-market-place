 

import UIKit

class AddRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var gImgView: UIImageView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gTxtFld: UITextField!
    @IBOutlet weak var gViewTxtFld: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
