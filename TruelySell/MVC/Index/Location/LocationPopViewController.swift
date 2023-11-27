 
import UIKit
import CoreLocation

class LocationPopViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet var myBtnEnableLocation: UIButton!
    @IBOutlet var myLblLocation: UILabel!
    @IBOutlet var myLblLocationContent: UILabel!
    @IBOutlet var myImgViewLocation: UIImageView!
    @IBOutlet var myBtnClose: UIButton!
    
    var aDictCommon = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NAVIGAION.hideNavigationBar(aViewController: self)
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
    }
    
    @objc func applicationDidBecomeActive() {

        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            //            self.dismiss(animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
     
//        changeLanguageContent()
        
        myBtnEnableLocation.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        HELPER.setRoundCornerView(aView: myBtnEnableLocation, borderRadius: 5.0)
        myBtnClose.isHidden = true
        myLblLocation.text = CommonTitle.LOCATION_ACCESS.titlecontent()
        myLblLocationContent.text = CommonTitle.LOCATION_ACCESS_CONTENT.titlecontent()
        
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: myImgViewLocation, imageName: "icon_location_alert")


    }

    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    @IBAction func btnLocationEnableTapped(_ sender: Any) {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
//                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    // Fallback on earlier versions
                }
            }
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        
        aDictCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
    }

}
