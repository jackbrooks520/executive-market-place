 

import UIKit

class NewSettingsNotifocationTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblTime: UILabel!
    @IBOutlet weak var gLblNotificationContent: UILabel!
    @IBOutlet weak var gImgViewUserImg: UIImageView!
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
