
import UIKit

class MyProviderHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gLblProviderStatus: UILabel!
    @IBOutlet weak var gImgTimeIcon: UIImageView!
    @IBOutlet weak var gImgDateIcon: UIImageView!
    @IBOutlet weak var gLblUserName: UILabel!
    @IBOutlet weak var gImgViewBullet1: UIImageView!
    @IBOutlet weak var gmyProfileImg: UIImageView!
    @IBOutlet var gLblTitle: UILabel!
    
    @IBOutlet weak var gLblBullet1: UILabel!
    
    @IBOutlet weak var gLblDate: UILabel!
    @IBOutlet weak var gLblTime: UILabel!
    @IBOutlet weak var gBtnShowDirections: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
