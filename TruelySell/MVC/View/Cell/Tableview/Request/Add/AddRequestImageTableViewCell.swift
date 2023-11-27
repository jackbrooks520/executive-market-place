
import UIKit

class AddRequestImageTableViewCell: UITableViewCell {

    @IBOutlet weak var gBtnImgTap: UIButton!
    @IBOutlet weak var gLblUploadContent: UILabel!
    @IBOutlet weak var gImgViewUploadCenter: UIImageView!
    @IBOutlet weak var gImgViewProvUploadImg: UIImageView!
    @IBOutlet weak var gContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
