
import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblCount: UILabel!
    @IBOutlet weak var gViewCount: UIView!
    @IBOutlet weak var gViewContainer: UIView!
    @IBOutlet weak var gImgView: UIImageView!
    @IBOutlet weak var gLblDateAndTIme: UILabel!
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gLblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
