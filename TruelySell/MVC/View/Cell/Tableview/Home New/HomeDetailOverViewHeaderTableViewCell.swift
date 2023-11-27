 

import UIKit

class HomeDetailOverViewHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblViews: UILabel!
    @IBOutlet weak var gContainerViewViews: UIView!
    @IBOutlet weak var gLblServiceName: UILabel!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gLblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
