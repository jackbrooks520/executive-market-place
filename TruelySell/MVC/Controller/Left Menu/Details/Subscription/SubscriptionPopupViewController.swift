 
import UIKit

class SubscriptionPopupViewController: UIViewController {

    @IBOutlet weak var popupview: UIView!
    @IBOutlet weak var skipNow: UIButton!
    @IBOutlet weak var goToSubscriptionBtn: UIButton!
    
    @IBOutlet weak var buySubscriptionLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var myImgSubscription: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: ProviderAndUserScreenTitle.SUBSCRIPTION_TITLE.titlecontent(), aViewController: self)
        popupview.layer.cornerRadius = 15
        popupview.layer.shadowColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor()).cgColor
        popupview.layer.shadowOffset = CGSize(width: 0, height: 10)
        popupview.layer.shadowOpacity = 0.9
        popupview.layer.shadowRadius = 5
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: myImgSubscription, imageName: "icon_subscription")
        goToSubscriptionBtn.setTitle(SubscriptionScreen.GO_TO_SUBSCRIPTION.titlecontent(), for: .normal)
        HELPER.setRoundCornerView(aView:goToSubscriptionBtn, borderRadius: 5)
        goToSubscriptionBtn.backgroundColor =  HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        skipNow.setTitle(SubscriptionScreen.SKIP_NOW.titlecontent(), for: .normal)
        skipNow.setTitleColor(HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), for: .normal)
        
        buySubscriptionLbl.text = SubscriptionScreen.BUY_SUBSCRIPTION.titlecontent()
        infoLbl.text = SubscriptionScreen.THANKS_FOR_UPGRADE.titlecontent()
        buySubscriptionLbl.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapOnSubscription(_ sender: Any) {
        
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHECKOUT_VC) as! CheckoutViewController
        
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    @IBAction func didTapOnNotnow(_ sender: Any) {
        self .dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
