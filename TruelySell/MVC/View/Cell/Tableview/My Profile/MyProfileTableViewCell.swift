 
import UIKit

class MyProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var gTextfield: UITextField!
    @IBOutlet weak var gSubscriptionBtn: UIButton!
  
    
    @IBOutlet weak var subscription_btn_width: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
