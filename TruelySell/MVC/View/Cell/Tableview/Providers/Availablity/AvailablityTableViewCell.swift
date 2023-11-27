
import UIKit

class AvailablityTableViewCell: UITableViewCell {

    @IBOutlet weak var gSwitch: UISwitch!
    @IBOutlet weak var gLblDays: UILabel!
    @IBOutlet weak var gViewTo: UIView!
    @IBOutlet weak var gViewFrom: UIView!
    @IBOutlet weak var gTxtFldTo: UITextField!
    @IBOutlet weak var gTxtFldFrom: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
