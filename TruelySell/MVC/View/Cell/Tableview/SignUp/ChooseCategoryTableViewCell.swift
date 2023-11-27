 
import UIKit

class ChooseCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gBtnChooseCategory: UIButton!
    @IBOutlet weak var gImgViewRightArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
