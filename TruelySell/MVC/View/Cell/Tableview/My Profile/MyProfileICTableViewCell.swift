 
import UIKit

class MyProfileICTableViewCell: UITableViewCell {

    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var gTextField: UITextField!
    @IBOutlet weak var gBtnImage: UIButton!
    @IBOutlet weak var gImgViewICCard: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
