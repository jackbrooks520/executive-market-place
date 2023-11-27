 

import UIKit

class SubscriptionSuccessViewController: UIViewController {
    
    @IBOutlet weak var myContainerViewNextBtn: UIView!
    @IBOutlet weak var myThanksLbl: UILabel!
    @IBOutlet weak var myInfoLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var myImgTick: UIImageView!
    
    var aDictLangSignUp = [String:Any]()
    var aDictCommon = [String:Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NAVIGAION.setNavigationTitle(aStrTitle: CommonTitle.SUCCESS.titlecontent(), aViewController: self)
        navigationItem.hidesBackButton = true
//        self .changeLanguageContent()
        
        myThanksLbl.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        nextBtn.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        nextBtn.setTitle(ProviderAndUserScreenTitle.NEXT_TITLE.titlecontent(), for: .normal)
        HELPER.setRoundCornerView(aView: myContainerViewNextBtn, borderRadius: 15.0)
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: myImgTick, imageName: "icon_tick_red")
        myThanksLbl.text = SubscriptionScreen.THANK_YOU.titlecontent()
        myInfoLbl.text = SubscriptionScreen.INFO_LABEL.titlecontent()
       
        
        
//        myInfoLbl.text = aDictLangSignUp["lg9_youre_going_to_"] as? String ?? ""
//        myThanksLbl.text = aDictLangSignUp["lg9_thank_you"] as? String ?? ""
        
        //        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: "Success", aViewController: self)
        //        setUpLeftBarBackButton()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
        leftBtn.setImage(UIImage(named: ICON_BACK)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)               }
                      else {
                         leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
                      }
//        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    @objc func backBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTaponNext(_ sender: Any) {
                
        APPDELEGATE.loadTabbar()
    }
    
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        aDictLangSignUp = aDictLangInfo["subscription"] as! [String : Any]
        
        aDictCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
    }

}
