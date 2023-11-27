 
import UIKit

class NewCategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var myViewColor: UIView!
    @IBOutlet weak var myLblNoDataContent: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var myLblHeaderTitleCategories: UILabel!
    let cellCategoryIdentifier = "CategoryListCollectionViewCell"
    
    var myArySubCatInfo = [[String:Any]]()
    
    var gStrCatId = String()
    var gStrCatName = String()
    var myIntTotalPage = Int()
    var currentIndex = 1
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI()  {
        
        myViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
        HELPER.setRoundCornerView(aView: myViewColor, borderRadius: 2.5)
        myCollectionView.isHidden = true
        myLblNoDataContent.isHidden = true
        myLblHeaderTitleCategories.text = CommonTitle.CATEGORIES_TITLE.titlecontent()
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            myLblHeaderTitleCategories.textAlignment = .right
        }
        else {
            myLblHeaderTitleCategories.textAlignment = .left
        }
        NAVIGAION.setNavigationTitle(aStrTitle: CommonTitle.CATEGORIES_TITLE.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(UINib(nibName: cellCategoryIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCategoryIdentifier)
    }
    
    func setUpModel()  {
        
    }
    
    func loadModel()  {
        
        getCategoryFromApi()
    }
    
    // MARK: - Collection View Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myArySubCatInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryIdentifier, for: indexPath) as! CategoryListCollectionViewCell
        
        HELPER.setRoundCornerView(aView: aCell.gViewCatImage)
        
        if myArySubCatInfo.count != 0 {
          
            let myStrImage:String = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["category_image"] as AnyObject) as! String  //myArySubCatInfo[indexPath.row]["category_image"] as! String
            
            aCell.gImgViewCatIcon.setShowActivityIndicator(true)
            aCell.gImgViewCatIcon.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewCatIcon.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: "icon_home_category"))
            
            aCell.gLblCatName.text = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["category_name"] as AnyObject) as? String  //myArySubCatInfo[indexPath.row]["category_name"] as? String
        }
        
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_SUB_CATEGORY_VC) as! NewSubCategoryViewController
        aViewController.gStrCatId = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["id"] as AnyObject) as! String  //myArySubCatInfo[indexPath.row]["id"]! as! String
        aViewController.gStrCatName = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["category_name"] as AnyObject) as! String  //myArySubCatInfo[indexPath.row]["category_name"]! as! String
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width) / 3, height: (collectionView.frame.width) / 3)
    }
    
    // MARK:- Api Call
    func getCategoryFromApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        var aDictParams = [String:String]()
        aDictParams["counts_per_page"] = "10"
        aDictParams["current_page"] = String(currentIndex)
        
        HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_PROFESSIONAL_CATEGOY, dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    self.myArySubCatInfo = aDictResponseData["category_list"] as! [[String : Any]]
                    
                    if self.myArySubCatInfo.count != 0 {
                        
                        self.myCollectionView.isHidden = false
                        self.myLblNoDataContent.isHidden = true
                        self.myCollectionView.reloadData()
                        HELPER.hideLoadingAnimation()
                    }
                    else {
                        
                        self.myCollectionView.isHidden = true
                        self.myLblNoDataContent.isHidden = false
                        self.myLblNoDataContent.text = HomeScreenContents.NO_CATEGORIES_FOUND.titlecontent()
                    }
                    
                    HELPER.hideLoadingAnimation()
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                    
                }
                else {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    // MARK:- Left Bar Button Methods
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
        leftBtn.setImage(UIImage(named: ICON_BACK)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal) }
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
}
