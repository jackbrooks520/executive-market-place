 
import UIKit

class NewSettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gViewLine: UIView!
    @IBOutlet weak var gLblListType: UILabel!
    @IBOutlet weak var gLblListName: UILabel!
    @IBOutlet weak var gimgViewLast: UIImageView!
    @IBOutlet weak var gImgViewFirst: UIImageView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet var gListTypeWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
