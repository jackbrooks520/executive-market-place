
import UIKit

class AdvSearchPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblTo: UILabel!
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gTextFieldPriceFrom: UITextField!
    @IBOutlet weak var gTextFieldPriceTo: UITextField!
    @IBOutlet weak var gTextFieldView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
