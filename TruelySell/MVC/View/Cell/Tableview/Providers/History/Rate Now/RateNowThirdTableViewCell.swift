
import UIKit
import AARatingBar

class RateNowThirdTableViewCell: UITableViewCell {
    @IBOutlet weak var gLblLeaveCommentsContent: UILabel!
    
    @IBOutlet weak var gViewRatingBar: AARatingBar!
    @IBOutlet weak var gViewTextView: UIView!
    @IBOutlet weak var gTxtViewComments: UITextView!
    @IBOutlet weak var gViewBtnSubmit: UIView!
    @IBOutlet weak var gBtnSubmit: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
