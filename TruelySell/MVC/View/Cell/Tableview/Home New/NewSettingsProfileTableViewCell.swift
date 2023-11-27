 
import UIKit

class NewSettingsProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblEditContent: UILabel!
    @IBOutlet weak var gViewEdit: UIView!
    @IBOutlet weak var gLblEmail: UILabel!
    @IBOutlet weak var gLblName: UILabel!
    @IBOutlet weak var gImgViewUserImage: UIImageView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gContainerViewUserImage: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
