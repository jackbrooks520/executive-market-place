 
import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var gBtnTandCContent: UIButton!
    @IBOutlet weak var gLblTandCContent: UILabel!
    @IBOutlet weak var gBtnTandC: UIButton!
    @IBOutlet weak var gBtnTandCCheck: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var gLblChooseContent: UILabel!
    @IBOutlet weak var gLblRequestorContent: UILabel!
    @IBOutlet weak var gProviderContent: UILabel!
    @IBOutlet weak var gBtnRequestor: UIButton!
    @IBOutlet weak var gBtnProvider: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
