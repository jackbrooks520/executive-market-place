 
import UIKit

class HomeNewProviderViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var myViewBottom: UIView!
    @IBOutlet var myBtnAdd: UIButton!
    
    @IBOutlet weak var myLblFirstContent: UILabel!
    @IBOutlet weak var myLblMiddleContent: UILabel!
    
    let cellCollectionIdentifier = "DashboardCollectionViewCell"
    
    var myDictResponseData = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpModel()
        loadModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NAVIGAION.hideNavigationBar(aViewController: self)
        super.viewWillAppear(animated)
        getServiceCountFromApi()
        let middleContentText = NSMutableAttributedString()
        middleContentText.append(NSAttributedString(string: CommonTitle.WORLDSLARGEST.titlecontent(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]));
        middleContentText.append(NSAttributedString(string: CommonTitle.MARKETPLACE.titlecontent(), attributes: [NSAttributedString.Key.foregroundColor: HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())]))
        myLblMiddleContent.attributedText = middleContentText
    }
    
    func setUpUI() {
        let firstContentText = NSMutableAttributedString()
        firstContentText.append(NSAttributedString(string: HOME_PAGE_APP_FIRST_NAME, attributes: [NSAttributedString.Key.foregroundColor: HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())]));
        firstContentText.append(NSAttributedString(string: HOME_PAGE_APP_LAST_NAME, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]))
        myLblFirstContent.attributedText = firstContentText
        
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.register(UINib.init(nibName: cellCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCollectionIdentifier)
        
        myViewBottom.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        HELPER.setRoundCornerView(aView: myViewBottom)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    
    // MARK: - Collection View Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCollectionIdentifier, for: indexPath) as! DashboardCollectionViewCell
        
        HELPER.setRoundCornerView(aView: cell.dashboardLblView, borderRadius: 2.5)
        cell.dashboardLblView.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
        cell.homeView.layer.cornerRadius = 10
        cell.homeView.clipsToBounds = true
        
        if myDictResponseData.count != 0 {
            
            if indexPath.row == 0{
                let myImg = "icon_dashboard_my_services.png"
                let myGradientImg = UIImage(named: myImg)
                cell.dashBoardImg.image = myGradientImg!.maskWithGradientColor()
                //                cell.dashBoardImg.image = UIImage(named: "icon_dashboard_my_services")
                cell.dashBoardTitle.text  = HomeScreenContents.MY_SERVICE.titlecontent() 
                cell.gLblCount.text = HELPER.returnStringFromNull(myDictResponseData["service_count"] as AnyObject) as? String//myDictResponseData["service_count"] as? String
            }else if indexPath.row == 1{
                
                
                let myImg = "icon_dashboard_buyer_request.png"
                let myGradientImg = UIImage(named: myImg)
                cell.dashBoardImg.image = myGradientImg!.maskWithGradientColor()
                
                //                cell.dashBoardImg.image = UIImage(named: "icon_dashboard_buyer_request")
                cell.dashBoardTitle.text  = HomeScreenContents.BUYER_REQUEST.titlecontent()
                cell.gLblCount.text = HELPER.returnStringFromNull(myDictResponseData["pending_service_count"] as AnyObject) as? String  //myDictResponseData["pending_service_count"] as? String
            }else if indexPath.row == 2{
                let myImg = "icon_dashboard_inprogresss.png"
                let myGradientImg = UIImage(named: myImg)
                cell.dashBoardImg.image = myGradientImg!.maskWithGradientColor()
                //                cell.dashBoardImg.image = UIImage(named: "icon_dashboard_inprogresss")
                cell.dashBoardTitle.text  = HomeScreenContents.IN_PROGRESS_SERVICES.titlecontent()
                cell.gLblCount.text = HELPER.returnStringFromNull(myDictResponseData["inprogress_service_count"] as AnyObject) as? String  //myDictResponseData["inprogress_service_count"] as? String
            }else{
                let myImg = "icon_dashboard_completed.png"
                let myGradientImg = UIImage(named: myImg)
                cell.dashBoardImg.image = myGradientImg!.maskWithGradientColor()
                //                cell.dashBoardImg.image = UIImage(named: "icon_dashboard_completed")
                cell.dashBoardTitle.text  =  HomeScreenContents.COMPLETED_SERVICES.titlecontent() 
                cell.gLblCount.text = HELPER.returnStringFromNull(myDictResponseData["complete_service_count"] as AnyObject) as? String  //myDictResponseData["complete_service_count"] as? String
            }
        }
        else {
            
            if indexPath.row == 0{
                let myImg = "icon_dashboard_my_services.png"
                let myGradientImg = UIImage(named: myImg)
                cell.dashBoardImg.image = myGradientImg!.maskWithGradientColor()
                //                cell.dashBoardImg.image = UIImage(named: "icon_dashboard_my_services")
                cell.dashBoardTitle.text  = HomeScreenContents.MY_SERVICE.titlecontent()
                cell.gLblCount.text = ""
                
            }else if indexPath.row == 1{
                //                cell.dashBoardImg.image = UIImage(named: "icon_dashboard_buyer_request")
                let myImg = "icon_dashboard_buyer_request.png"
                let myGradientImg = UIImage(named: myImg)
                cell.dashBoardImg.image = myGradientImg!.maskWithGradientColor()
                
                cell.dashBoardTitle.text  = HomeScreenContents.BUYER_REQUEST.titlecontent()
                cell.gLblCount.text = ""
            }else if indexPath.row == 2{
                let myImg = "icon_dashboard_inprogresss.png"
                let myGradientImg = UIImage(named: myImg)
                cell.dashBoardImg.image = myGradientImg!.maskWithGradientColor()
                //                cell.dashBoardImg.image = UIImage(named: "icon_dashboard_inprogresss")
                cell.dashBoardTitle.text  = HomeScreenContents.IN_PROGRESS_SERVICES.titlecontent()
                cell.gLblCount.text = ""
            }else{
                let myImg = "icon_dashboard_completed.png"
                let myGradientImg = UIImage(named: myImg)
                cell.dashBoardImg.image = myGradientImg!.maskWithGradientColor()
                //                cell.dashBoardImg.image = UIImage(named: "icon_dashboard_completed")
                cell.dashBoardTitle.text  = HomeScreenContents.COMPLETED_SERVICES.titlecontent()
                cell.gLblCount.text = ""
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { //My Service
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_PROVIDER_SERVICE_LIST_VC) as! ProviderServiceListViewController
            aViewController.gIsClickFromMyService = true
            aViewController.gIsClickFromBuyerRequest = false
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        else if indexPath.row == 1 { //Buyer Request
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_PROVIDER_SERVICE_LIST_VC) as! ProviderServiceListViewController
            aViewController.gIsClickFromMyService = false
            aViewController.gIsClickFromBuyerRequest = true
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        else if indexPath.row == 2 { //In-Progress Services
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PROVIDER_STATUS_SERVICE_VC) as! ProviderStatusServiceViewController
            aViewController.isFromInProgress = true
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        else { //Completed Services
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PROVIDER_STATUS_SERVICE_VC) as! ProviderStatusServiceViewController
            aViewController.isFromInProgress = false
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
    }
    
    // MARK: - Api call
    func getServiceCountFromApi() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_PROVIDER_DASHBOARD_COUNT, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            print(response)
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : Any]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if aDictResponse[kRESPONSE_CODE] as? Int == kRESPONSE_CODE_DATA {
                self.myDictResponseData = response["data"] as! [String : Any]
                self.myCollectionView .reloadData()
                }
               else if aDictResponse[kRESPONSE_CODE] as? String == "200" {
                self.myDictResponseData = response["data"] as! [String : Any]
                self.myCollectionView .reloadData()
                }
                else {
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse as! String)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    // MARK: - Button Action
    @IBAction func btnAddTapped(_ sender: Any) {
        
        if SESSION.getUserSubscriptionStatus() {
            
            let aViewController:ProvideAddViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_ADD_PROVIDE) as! ProvideAddViewController
            aViewController.gClickEditProvide = false
            let naviController = UINavigationController(rootViewController: aViewController)
            self.present(naviController, animated: true, completion: nil)
        }
        else {
            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_POPUP_VC) as! SubscriptionPopupViewController
            
            aViewController.modalPresentationStyle = .overFullScreen
            aViewController.modalTransitionStyle = .crossDissolve
            let naviController = UINavigationController(rootViewController: aViewController)
            self.present(naviController, animated: true, completion: nil)
        }
    }
}
