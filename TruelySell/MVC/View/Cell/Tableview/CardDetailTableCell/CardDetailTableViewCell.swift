
import UIKit

class CardDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var cardInfoView: UIImageView!
    @IBOutlet weak var uploadCardBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
