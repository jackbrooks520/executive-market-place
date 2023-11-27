
import UIKit
import AARatingBar

class RateListTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblDateandTime: UILabel!
    @IBOutlet weak var gLblComments: UILabel!
    @IBOutlet weak var gViewRatingBar: AARatingBar!
    @IBOutlet weak var gLblName: UILabel!
    @IBOutlet weak var gImgUser: UIImageView!
    @IBOutlet weak var gViewUserImg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
