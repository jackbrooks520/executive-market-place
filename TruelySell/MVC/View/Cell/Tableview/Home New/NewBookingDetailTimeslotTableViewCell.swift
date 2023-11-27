 
import UIKit

class NewBookingDetailTimeslotTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblToTime: UILabel!
    @IBOutlet weak var gLblFromTime: UILabel!
    @IBOutlet weak var gLblBookedDate: UILabel!
    @IBOutlet weak var gLblTitleToTime: UILabel!
    @IBOutlet weak var gLblTitleFromTime: UILabel!
    @IBOutlet var myViewRescheduleContainer: UIView!
    @IBOutlet var myBtnReschedule: UIButton!
    @IBOutlet var gRescheduleHeightConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
