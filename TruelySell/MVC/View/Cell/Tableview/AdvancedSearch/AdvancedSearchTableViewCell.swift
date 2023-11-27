
import UIKit

class AdvancedSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gTextField: UITextField!
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
