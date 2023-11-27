
import UIKit
import MapViewPlus

public protocol BasicCalloutViewModelDelegate: class {
    func detailButtonTapped(withTitle title: String , withId id: String)
}

class BasicCalloutView: UIView {
	
	weak var delegate: BasicCalloutViewModelDelegate?
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var button: UIButton!
    @IBOutlet var gLblCategory: UILabel!
    @IBOutlet var gLblPrice: UILabel!
    
    @IBOutlet var myViewImg: UIView!
    var striId = String()
	@IBAction func buttonTouchDown(_ sender: Any) {
        delegate?.detailButtonTapped(withTitle: label.text!, withId: striId)
	}
}

extension BasicCalloutView: CalloutViewPlus{
	func configureCallout(_ viewModel: CalloutViewModel) {
        
		let viewModel = viewModel as! ImageAnnotation
        
        label.text = viewModel.title
        gLblCategory.text = viewModel.subtitle
        gLblPrice.text = viewModel.price
        striId = viewModel.jobId!
        imageView.sd_setImage(with: URL(string: (WEB_BASE_URL + (viewModel.image ?? ""))), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
        button.layer.cornerRadius = button.layer.frame.height / 2
        label.textColor = UIColor.black
        gLblPrice.textColor = UIColor.black
        gLblCategory.textColor = UIColor.black
        button.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        self.layer.cornerRadius = 10
        myViewImg.layer.cornerRadius = 10
        self.backgroundColor =  UIColor.white//HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
//        imageView.image = UIImage(named: WEB_BASE_URL + (viewModel.image ?? ""))
	}
}
