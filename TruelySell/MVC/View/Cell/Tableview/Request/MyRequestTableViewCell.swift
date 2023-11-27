
import UIKit

class MyRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var gLblUserName: UILabel!
    @IBOutlet weak var gImgViewBullet2: UIImageView!
    @IBOutlet weak var gImgViewBullet1: UIImageView!
    @IBOutlet weak var gImgViewBullet3: UIImageView!
    @IBOutlet weak var gmyProfileImg: UIImageView!
    @IBOutlet var gLblProfileUser: UILabel!
    
    @IBOutlet weak var gLblBullet1: UILabel!
    @IBOutlet weak var gLblBullet2: UILabel!
    @IBOutlet weak var gLblBullet3: UILabel!
    
    @IBOutlet weak var gLblDate: UILabel!
    @IBOutlet weak var gLblTime: UILabel!
    @IBOutlet weak var gLblAmount: UILabel!
    @IBOutlet weak var gLblStatus: UILabel!

    
    @IBOutlet var gLblAppointment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
