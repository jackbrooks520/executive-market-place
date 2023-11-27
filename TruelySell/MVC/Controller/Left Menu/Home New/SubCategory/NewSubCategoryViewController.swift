 
import UIKit

class NewSubCategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myViewColor: UIView!
    @IBOutlet weak var myLblNoDataContent: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var myLblHeaderSubCategories: UILabel!
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
        myLblHeaderSubCategories.text = CommonTitle.SUB_CATEGORIES_TITLE.titlecontent()
    
         if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            myLblHeaderSubCategories.textAlignment = .right
        }
         else {
            myLblHeaderSubCategories.textAlignment = .left
            
        }
        HELPER.setRoundCornerView(aView: myViewColor, borderRadius: 2.5)
        myCollectionView.isHidden = true
        myLblNoDataContent.isHidden = true
        NAVIGAION.setNavigationTitle(aStrTitle: gStrCatName, aViewController: self)
        setUpLeftBarBackButton()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(UINib(nibName: cellCategoryIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCategoryIdentifier)
    }
    
    func setUpModel()  {
        
    }
    
    func loadModel()  {
        
        getSubCategoryFromApi(catId: gStrCatId)
    }

    // MARK: - Collection View Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myArySubCatInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryIdentifier, for: indexPath) as! CategoryListCollectionViewCell
        
        HELPER.setRoundCornerView(aView: aCell.gViewCatImage)
        
        if myArySubCatInfo.count != 0 {
            
            let myStrImage: String = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["subcategory_image"] as AnyObject) as! String
            
            aCell.gImgViewCatIcon.setShowActivityIndicator(true)
            aCell.gImgViewCatIcon.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewCatIcon.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: "icon_home_category"))
            
            aCell.gLblCatName.text = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["subcategory_name"] as AnyObject) as? String //myArySubCatInfo[indexPath.row]["subcategory_name"] as? String
        }
        
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SERVICE_LIST_VC) as! ServicesListViewController
        aViewController.gStrSubCatId = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["id"] as AnyObject) as! String //myArySubCatInfo[indexPath.row]["id"] as! String
        aViewController.gStrSubCatName = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["subcategory_name"] as AnyObject) as! String //myArySubCatInfo[indexPath.row]["subcategory_name"] as! String
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width) / 3, height: (collectionView.frame.width) / 3)
    }

    // MARK:- Api Call
    func getSubCategoryFromApi(catId:String) {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["category"] = catId
        aDictParams["counts_per_page"] = "20"
        aDictParams["current_page"] = String(currentIndex)
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_PROFESSIONAL_SUB_CATEGOY,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    if self.myArySubCatInfo.count == 0 {
                        self.myArySubCatInfo = aDictResponseData["subcategory_list"] as! [[String : Any]]
                    }
                    else {
                        for dictInfo in  aDictResponseData["subcategory_list"] as! [[String : Any]]  {
                            self.myArySubCatInfo.append(dictInfo)
                        }
                    }
                    if self.myArySubCatInfo.count != 0 {
                    
                        self.myIntTotalPage = Int(response["total_pages"] as? String ?? "0")!
                        if  self.currentIndex == self.myIntTotalPage || self.myIntTotalPage == 0 {
                            self.isLoading = false
                           
                        } else {
                            self.isLoading = true
                        }
                        
                        self.currentIndex = Int(response["next_page"] as? String ?? "0")!
                        self.myCollectionView.isHidden = false
                        self.myLblNoDataContent.isHidden = true
                        self.myCollectionView.reloadData()
                        HELPER.hideLoadingAnimation()
                    }
                    else {
                        self.isLoading = false
                        self.myCollectionView.isHidden = true
                        self.myLblNoDataContent.isHidden = false
                        self.myLblNoDataContent.text = CommonTitle.NO_SUB_CATEGORIES_FOUND.titlecontent()
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
}
