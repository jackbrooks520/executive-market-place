
import UIKit

class AddRequestTextViewTableViewCell: UITableViewCell {

    @IBOutlet weak var gBtnFrontIcon: UIButton!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gBtnClose: UIButton!
    @IBOutlet weak var gViewTxtView: UIView!
    @IBOutlet weak var gTxtView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
