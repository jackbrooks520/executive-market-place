

import UIKit
import MXSegmentedControl
import AARatingBar
import Presentr
import CoreLocation

class HomeNewDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,iCarouselDataSource,iCarouselDelegate, CLLocationManagerDelegate {
   
   @IBOutlet weak var myLblNoDataContent: UILabel!
   @IBOutlet weak var myConstraintHeightBook: NSLayoutConstraint!
   @IBOutlet weak var myBtnBook: UIButton!
   @IBOutlet weak var myContainerViewBook: UIView!
   @IBOutlet weak var mySegmentControl: MXSegmentedControl!
   @IBOutlet weak var myTblView: UITableView!
   
   let cellTableHeaderIdentifier = "HomeNewHeaderTableViewCell"
   let cellTableDetailHeaderIdentifier = "HomeNewHeaderTableViewCell"
   
   //OverView
   let cellTableDetailOverViewHeaderIdentifier = "HomeDetailOverViewHeaderTableViewCell"
   let cellTableDetailOverViewFirstIdentifier = "HomeDetailOverViewColletionViewTableViewCell"
   let cellTableDetailOverViewSecondIdentifier = "HomeDetailOverViewPriceTableViewCell"
   let cellTableDetailOverViewThirdIdentifier = "HomeDetailOverViewDescriptionTableViewCell"
   let cellTableDetailOverViewFourthIdentifier = "HomeDetailOverViewBookButtonTableViewCell"
   let cellServiceListCollectionIdentifier = "ServiceListNewCollectionViewCell"
   let cellCollectionDetailOverViewIdentifier = "HomeNewOverViewGalleryCollectionViewCell"
   
   //About Seller
   let cellTableDetailSellerHeaderIdentifier = "HomeDetailSellerHeaderTableViewCell"
   let cellTableDetailSellerFirstIdentifier = "HomeDetailSellerProfileTableViewCell"
   let cellTableDetailSellerSecondIdentifier = "HomeDetailSellerLocationTableViewCell"
   let cellTableDetailSellerThirdIdentifier = "HomeNewCollectionViewTableViewCell"
   
   //Comments
   let cellTableDetailReviewsFirstIdentifier = "RateListTableViewCell"
   
   
   //Temp
   let cellTableViewAllListIdentifier = "ViewAllListTableViewCell"
   
   var myDictOverView = [String:Any]()
   var myDictAboutSeller = [String:Any]()
   var myAryReviews = [[String:Any]]()
   var myAryUserServices = [[String:Any]]()
   
   var isFromProvider:Bool = false
   
   //temp
   
   var myAryImage: [String] = []
   
   var gStrServiceId = String()
   var myStrLatitude = String()
   var myStrLongitude = String()
   var myStrProviderName = String()
   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       setUpUI()
       setUpModel()
       loadModel()
       
       // Do any additional setup after loading the view.
   }
   
   override func viewWillAppear(_ animated: Bool) {
       
       if SESSION.getUserToken().count == 0 {
           
           setUpRightBarButton()
       }
   }
   
   func setUpUI() {
       
       myLblNoDataContent.isHidden = true
       NAVIGAION.setNavigationTitle(aStrTitle: Booking_service.SERVICE_DETAIL.titlecontent(), aViewController: self)
       
       setUpLeftBarBackButton()
       
       mySegmentControl.append(title: BookingDetailService.OVERVIEW.titlecontent())
       mySegmentControl.append(title: BookingDetailService.ABOUT_SELLER.titlecontent())
       mySegmentControl.append(title: Booking_service.REVIEWS.titlecontent())
       mySegmentControl.font =  UIFont.systemFont(ofSize: 14)
       mySegmentControl.indicatorColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       mySegmentControl.selectedTextColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       
       myContainerViewBook.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       myBtnBook.setTitle(ViewAllServices.BOOK.titlecontent(), for: .normal)
       
       myTblView.delegate = self
       myTblView.dataSource = self
       
       myTblView.register(UINib.init(nibName: cellTableHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableHeaderIdentifier)
       
       //OverView
       
       myTblView.register(UINib.init(nibName: cellTableDetailOverViewHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailOverViewHeaderIdentifier)
       myTblView.register(UINib.init(nibName: cellTableDetailOverViewFirstIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailOverViewFirstIdentifier)
       myTblView.register(UINib.init(nibName: cellTableDetailOverViewSecondIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailOverViewSecondIdentifier)
       myTblView.register(UINib.init(nibName: cellTableDetailOverViewThirdIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailOverViewThirdIdentifier)
       myTblView.register(UINib.init(nibName: cellTableDetailOverViewFourthIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailOverViewFourthIdentifier)
       
       //About Seller
       
       myTblView.register(UINib.init(nibName: cellTableDetailSellerHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailSellerHeaderIdentifier)
       myTblView.register(UINib.init(nibName: cellTableDetailSellerFirstIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailSellerFirstIdentifier)
       myTblView.register(UINib.init(nibName: cellTableDetailSellerSecondIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailSellerSecondIdentifier)
       myTblView.register(UINib.init(nibName: cellTableDetailSellerThirdIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailSellerThirdIdentifier)
       
       //Comments
       myTblView.register(UINib.init(nibName: cellTableDetailReviewsFirstIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailReviewsFirstIdentifier)
       
       //Temp
       myTblView.register(UINib.init(nibName: cellTableViewAllListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewAllListIdentifier)
       
       if isFromProvider == true {
           
           myConstraintHeightBook.constant = 0
       }
       else {
           
           myConstraintHeightBook.constant = 50
       }
   }
   
   func setUpModel() {
       
   }
   
   func loadModel() {
       
       getServiceDetailApi(listId: gStrServiceId)
       if SESSION.getUserLogInType() == "1" {
       setServiceViewsApi()
       }
   }
   
   // MARK: - Table View delegate and datasource
   func numberOfSections(in tableView: UITableView) -> Int {
       
       if mySegmentControl.selectedIndex == 1 {
           
           return 3
       }
       else {
           
           return 1
       }
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       if mySegmentControl.selectedIndex == 0 {
           
           return 5
       }
       else if mySegmentControl.selectedIndex == 1 {
           
           return 1
       }
       else {
           
           return myAryReviews.count
       }
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
       if mySegmentControl.selectedIndex == 1 {
           
           if section == 0 {
               
               return 0
           }
           else {
               
               return 50
           }
       }
       return 0
   }
   
   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       
       return UITableView.automaticDimension
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
       if mySegmentControl.selectedIndex == 0 {
           
           if indexPath.row == 0 {
               
               return 80
           }
           else if indexPath.row == 1 {
               
               return 250
           }
           else if indexPath.row == 2 {
               
               return 50
           }
           //            else if indexPath.row == 3 {
           //
           //                return 200
           //            }
           else {
               
               return UITableView.automaticDimension
           }
       }
       else if mySegmentControl.selectedIndex == 1 {
           
           if indexPath.section == 0 {
               
               return 130
           }
           else if indexPath.section == 1 {
               
               return 60
           }
           else {
               
               return 190
           }
       }
       else {
           
           return 100
       }
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
       if mySegmentControl.selectedIndex == 1 {
           
           var aCell:HomeDetailSellerHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableDetailSellerHeaderIdentifier) as? HomeDetailSellerHeaderTableViewCell
           
           aCell?.gBtnViewOnMap.tag = section
           aCell?.gLblViewOnMapContent.text = ViewAllServices.VIEW_ON_MAP.titlecontent()
           aCell?.gLblViewOnMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
           HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell?.gImgMapLocation, imageName: "icon_map_view_all")
           
           //        aCell?.gBtnViewAll.addTarget(self, action: #selector(self.filterBtnTapped(sender:)), for: .touchUpInside)
           
           aCell?.backgroundColor = UIColor.clear
           
           if  (aCell == nil) {
               
               let nib:NSArray=Bundle.main.loadNibNamed(cellTableDetailSellerHeaderIdentifier, owner: self, options: nil)! as NSArray
               aCell = nib.object(at: 0) as? HomeDetailSellerHeaderTableViewCell
           }
           
           else {
               
               if section == 1 {
                   
                   aCell?.gLblHeader.text = Booking_service.LOCATION.titlecontent()
                   aCell?.gContainerViewOnMap.isHidden = false
                   aCell?.gBtnViewOnMap.addTarget(self, action: #selector(self.viewonmapbtntapped(sender:)), for: .touchUpInside)
               }
               else if section == 2 {
                   
                   aCell?.gLblHeader.text = Booking_service.OTHER_RELATED_SERVICE.titlecontent()
                   aCell?.gContainerViewOnMap.isHidden = true
               }
               
               
               aCell?.gViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
               HELPER.setRoundCornerView(aView: aCell!.gViewColor, borderRadius: 2.5)
           }
           
           aCell?.gViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
           //            HELPER.setRoundCornerView(aView: aCell!.gViewColor, borderRadius: 2.5)
           
           return aCell
       }
       else {
           
           return nil
       }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       if mySegmentControl.selectedIndex == 0 { //OverView
           
           if indexPath.row == 0 {
               
               let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailOverViewHeaderIdentifier, for: indexPath) as! HomeDetailOverViewHeaderTableViewCell
               
               if myDictOverView.count != 0 {
                   
                   let aStrCurrency = HELPER.returnStringFromNull(myDictOverView["currency"] as AnyObject) as? String //myDictOverView["currency"] as? String
                   let aStrAmount = HELPER.returnStringFromNull(myDictOverView["service_amount"] as AnyObject) as? String //myDictOverView["service_amount"] as? String
                   if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                       aCell.gLblPrice.textAlignment = .left
                   }
                   else {
                       aCell.gLblPrice.textAlignment = .right
                   }
                   aCell.gLblPrice.text = aStrCurrency!.html2String + aStrAmount!
                   aCell.gLblServiceName.text = HELPER.returnStringFromNull(myDictOverView["service_title"] as AnyObject) as? String //myDictOverView["service_title"] as? String
                   aCell.gLblViews.text = (HELPER.returnStringFromNull(myDictOverView["views"] as AnyObject) as? String)! + BookingDetailService.VIEWS.titlecontent()
               }
               
               HELPER.setBorderView(aView: aCell.gContainerViewViews
                                    , borderWidth: 1.5, borderColor: .lightGray, cornerRadius: 15.0)
               
               return aCell
           }
           else if indexPath.row == 1 {
               
               let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailOverViewFirstIdentifier, for: indexPath) as! HomeDetailOverViewColletionViewTableViewCell
               
               aCell.gViewCarousel.delegate = self
               aCell.gViewCarousel.dataSource = self
               aCell.gViewCarousel.type = .rotary
               
               aCell.gViewCarousel.reloadData()
               
               return aCell
           }
           else if indexPath.row == 2 {
               
               let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailOverViewSecondIdentifier, for: indexPath) as! HomeDetailOverViewPriceTableViewCell
               
               if myDictOverView.count != 0 {
                   
                   aCell.gLblCategory.text = HELPER.returnStringFromNull(myDictOverView["category_name"] as AnyObject) as? String //myDictOverView["category_name"] as? String
                   aCell.gViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                   HELPER.setRoundCornerView(aView: aCell.gViewCategory, borderRadius: 15.0)
                   
                   let aStrRatingCount:String = (HELPER.returnStringFromNull(myDictOverView["rating_count"] as AnyObject) as? String)! //(myDictOverView["rating_count"] as? String)!
                   
                   aCell.gLblRating.text = "(" + aStrRatingCount + ")"
                   
                   let aStrRatingValue:String = (HELPER.returnStringFromNull(myDictOverView["ratings"] as AnyObject) as? String)! //(myDictOverView["ratings"] as? String)!
                   let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
                   
                   aCell.gViewRatingBar.isUserInteractionEnabled = false
                   aCell.gViewRatingBar.isAbsValue = false
                   
                   aCell.gViewRatingBar.maxValue = 5
                   aCell.gViewRatingBar.value = aCGFloatRatingValue
                   
               }
               return aCell
           }
           else if indexPath.row == 3 {
               
               let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailOverViewThirdIdentifier, for: indexPath) as! HomeDetailOverViewDescriptionTableViewCell
               
               aCell.gLblDescriptionContent.text = BookingDetailService.DESCRIPTION.titlecontent()
               aCell.gLblDescription.text = HELPER.returnStringFromNull(myDictOverView["about"] as AnyObject) as? String //myDictOverView["about"] as? String
               
               return aCell
           }
           else {
               
               let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailOverViewThirdIdentifier, for: indexPath) as! HomeDetailOverViewDescriptionTableViewCell
               
               aCell.gLblDescriptionContent.text = BookingDetailService.SERVICE_OFFERED.titlecontent()
               
               if myDictOverView.count != 0 {
                   let aStrJson = HELPER.returnStringFromNull(myDictOverView["service_offered"] as AnyObject) as? String //myDictOverView["service_offered"] as? String
                   
                   if aStrJson!.count != 0 {
                       
                       let data = aStrJson?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                       
                       do {
                           let arrayString = try JSONSerialization.jsonObject(with: data!, options: []) as! [String]
                           aCell.gLblDescription.attributedText = add(stringList: arrayString, font: aCell.gLblDescriptionContent.font, bullet: "")
                           
                       } catch let error as NSError {
                           print("Failed to load: \(error.localizedDescription)")
                       }
                   }
               }
               
               return aCell
               
               
           }
           
       }
       else if mySegmentControl.selectedIndex == 1 { //About Seller
           
           if indexPath.section == 0 {
               
               let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailSellerFirstIdentifier, for: indexPath) as! HomeDetailSellerProfileTableViewCell
               
               HELPER.setRoundCornerView(aView: aCell.gViewImage)
               aCell.gViewImage.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
               
               aCell.gImgViewProfilePic.layer.cornerRadius = aCell.gImgViewProfilePic.layer.frame.height / 2
               aCell.gViewChatCallWidthConstraint.constant = 0
               aCell.gImgViewCall.isHidden = true
               aCell.gImgViewChat.isHidden = true
               
               let aStrUserImg: String = HELPER.returnStringFromNull(myDictAboutSeller["profile_img"] as AnyObject) as! String  //myDictAboutSeller["profile_img"]! as! String
               let aStrCountryCode: String = HELPER.returnStringFromNull(myDictAboutSeller["country_code"] as AnyObject) as! String  //myDictAboutSeller["country_code"]! as! String
               let aStrMobNo: String = HELPER.returnStringFromNull(myDictAboutSeller["mobileno"] as AnyObject) as! String  //myDictAboutSeller["mobileno"]! as! String
               
               aCell.gLblName.text = HELPER.returnStringFromNull(myDictAboutSeller["name"] as AnyObject) as? String  //myDictAboutSeller["name"] as? String
               aCell.gLblEmail.text = HELPER.returnStringFromNull(myDictAboutSeller["email"] as AnyObject) as? String  //myDictAboutSeller["email"] as? String
               aCell.gLblMobNumb.text = aStrCountryCode + " " + aStrMobNo
               aCell.gViewBlock.isHidden = true
               aCell.gBtnBlock.isHidden = true
               aCell.gImgViewProfilePic.setShowActivityIndicator(true)
               aCell.gImgViewProfilePic.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
               aCell.gImgViewProfilePic.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
               //                aCell.gBtnBlock.addTarget(self, action: #selector(blockBtnTapped), for: .touchUpInside)
               return aCell
           }
           else if indexPath.section == 1 {
               
               let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailSellerSecondIdentifier, for: indexPath) as! HomeDetailSellerLocationTableViewCell
               
               aCell.gLblLocation.text = HELPER.returnStringFromNull(myDictAboutSeller["location"] as AnyObject) as? String  //myDictAboutSeller["location"] as? String
               
               return aCell
           }
           else {
               
               let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailSellerThirdIdentifier, for: indexPath) as! HomeNewCollectionViewTableViewCell
               
               if myAryUserServices.count != 0 {
                   
                   aCell.gCategoryCollectionView.isHidden = false
                   aCell.gLblNoRecordContent.isHidden = true
                   aCell.gViewEnableLocationContainer.isHidden = true
                   aCell.gCategoryCollectionView.delegate = self
                   aCell.gCategoryCollectionView.dataSource = self
                   aCell.gCategoryCollectionView.tag = indexPath.section
                   
                   aCell.gCategoryCollectionView.register(UINib(nibName: cellServiceListCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellServiceListCollectionIdentifier)
                   
                   aCell.gCategoryCollectionView.reloadData()
               }
               else {
                   
                   aCell.gCategoryCollectionView.isHidden = true
                   aCell.gViewEnableLocationContainer.isHidden = true
                   aCell.gLblNoRecordContent.isHidden = false
                   aCell.gLblNoRecordContent.text = BookingDetailService.NO_OTHER_SERVICE_FOUND.titlecontent()
               }
               
               return aCell
           }
           
       }
       else { // Comments
           
           let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailReviewsFirstIdentifier, for: indexPath) as! RateListTableViewCell
           
           if myAryReviews.count != 0 {
               
               aCell.gViewUserImg.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
               let aStrUserImg: String = HELPER.returnStringFromNull(myAryReviews[indexPath.row]["profile_img"] as AnyObject) as! String //myDictAboutSeller["profile_img"]! as! String
               
               aCell.gLblName.text = HELPER.returnStringFromNull(myAryReviews[indexPath.row]["name"] as AnyObject) as? String //myAryReviews[indexPath.row]["name"] as? String
               aCell.gLblComments.text = HELPER.returnStringFromNull(myAryReviews[indexPath.row]["review"] as AnyObject) as? String //myAryReviews[indexPath.row]["review"] as? String
               aCell.gLblDateandTime.text = HELPER.returnStringFromNull(myAryReviews[indexPath.row]["created"] as AnyObject) as? String //myAryReviews[indexPath.row]["created"] as? String
               
               HELPER.setRoundCornerView(aView: aCell.gViewUserImg)
               HELPER.setRoundCornerView(aView: aCell.gImgUser)
               aCell.gImgUser.setShowActivityIndicator(true)
               aCell.gImgUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
               aCell.gImgUser.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
               
               let aStrRatingValue:String = (HELPER.returnStringFromNull(myAryReviews[indexPath.row]["rating"] as AnyObject) as? String)! //(myAryReviews[indexPath.row]["rating"] as? String)!
               let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
               
               aCell.gViewRatingBar.isUserInteractionEnabled = false
               aCell.gViewRatingBar.isAbsValue = false
               
               aCell.gViewRatingBar.maxValue = 5
               aCell.gViewRatingBar.value = aCGFloatRatingValue
               
           }
           
           return aCell
       }
   }
   
   // MARK: - Collection View Delegate and Datasource
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
       return myAryUserServices.count == 0 ? 0 : myAryUserServices.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
       let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellServiceListCollectionIdentifier, for: indexPath) as! ServiceListNewCollectionViewCell
       
       HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10)
       
       HELPER.setBorderView(aView:  aCell.gContainerViewUserImage, borderWidth: 2, borderColor: UIColor.white, cornerRadius: 5)
       HELPER.setRoundCornerView(aView: aCell.gViewDistance, borderRadius: 5)
       
       aCell.gViewDistance.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
       HELPER.setRoundCornerView(aView: aCell.gContainerViewCategory, borderRadius: 5)
       if SESSION.getUserLatLong().0 != "" && SESSION.getUserLatLong().1 != "" && myAryUserServices[indexPath.row]["service_latitude"] as! String != "" && myAryUserServices[indexPath.row]["service_longitude"] as! String != "" {
           aCell.gViewDistance.isHidden = false
       let firsLocation = CLLocation(latitude:Double(SESSION.getUserLatLong().0)!, longitude:Double(SESSION.getUserLatLong().1)!)
          
       let doubleServiceLat = Double(myAryUserServices[indexPath.row]["service_latitude"] as? String ?? "0.0")!
       let doubleServiceLong = Double(myAryUserServices[indexPath.row]["service_longitude"] as? String ?? "0.0")!
       let secondLocation = CLLocation(latitude: doubleServiceLat, longitude: doubleServiceLong)
       let distance = firsLocation.distance(from: secondLocation) / 1000
       aCell.gLblDistance.text = "\(String(format:"%.02f", distance)) KM"
       aCell.gLblDistance.textColor = UIColor.black
       } else {
           aCell.gViewDistance.isHidden = true
       }
       aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())

       if myAryUserServices.count != 0 {
           
           let aStrUserImg: String = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["service_image"] as AnyObject) as! String //myAryUserServices[indexPath.row]["service_image"]! as! String
           let aStrRatingCount: String = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["rating_count"] as AnyObject) as! String //myAryUserServices[indexPath.row]["rating_count"]! as! String
           let aStrCurrency = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["currency"] as AnyObject) as! String //(myAryUserServices[indexPath.row]["currency"] as? String)!
           let aStrAmount = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["service_amount"] as AnyObject) as! String //(myAryUserServices[indexPath.row]["service_amount"] as? String)!
           
           aCell.gImgViewUserImage.setShowActivityIndicator(true)
           aCell.gImgViewUserImage.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
           aCell.gImgViewUserImage.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: ICON_PLACEHOLDER_SQUARE))
           
           aCell.gImgViewServiceList.setShowActivityIndicator(true)
           aCell.gImgViewServiceList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
           aCell.gImgViewServiceList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
           
           aCell.gLblServiceName.text = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["service_title"] as AnyObject) as? String //myAryUserServices[indexPath.row]["service_title"] as? String
           aCell.gLblCategoryName.text = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["category"] as AnyObject) as? String //myAryUserServices[indexPath.row]["category"] as? String
           aCell.gLblRateCount.text = "(" + aStrRatingCount + ")"
           aCell.gLblPrice.text = aStrCurrency.html2String + aStrAmount
           aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
           if SESSION.getUserToken().count == 0 {
               aCell.gBtnFav.isHidden = true
           }
           else {
               aCell.gBtnFav.isHidden = false
               //                if (myAryUserServices[indexPath.row]["service_favorite"] as? NSString)?.doubleValue == 1 {
               if myAryUserServices[indexPath.row]["service_favorite"] as? String == "1" {
                   aCell.gBtnFav.isSelected = true
               }
               else {
                   aCell.gBtnFav.isSelected = false
               }
               aCell.gBtnFav.tag = indexPath.row
               aCell.gBtnFav.addTarget(self, action: #selector(favouriteBtnTapped), for: .touchUpInside)
           }
       }
       
       return aCell
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       return CGSize(width: 250, height: 190)
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_DETAIL_VC) as! HomeNewDetailViewController
       aViewController.gStrServiceId = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["service_id"] as AnyObject) as! String //myAryUserServices[indexPath.row]["service_id"]! as! String
       self.navigationController?.pushViewController(aViewController, animated: true)
   }
   
   // MARK: - iCarousel delegate and datasorce
   func numberOfItems(in carousel: iCarousel) -> Int {
       
       return myAryImage.count
   }
   
   func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
       var label: UILabel
       var itemView: UIImageView
       
       //reuse view if available, otherwise create a new view
       if let view = view as? UIImageView {
           itemView = view
           //get a reference to the label in the recycled view
           label = itemView.viewWithTag(1) as! UILabel
       } else {
           //don't do anything specific to the index within
           //this `if ... else` statement because the view will be
           //recycled and used with other index values later
           itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
           
           itemView.setShowActivityIndicator(true)
           itemView.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
           itemView.sd_setImage(with: URL(string: WEB_BASE_URL + myAryImage[index]), placeholderImage: nil)
           
           //            itemView.image = UIImage(named: )
           itemView.contentMode = .center
           
           label = UILabel(frame: itemView.bounds)
           label.backgroundColor = .clear
           label.textAlignment = .center
           label.font = label.font.withSize(50)
           label.tag = 1
           itemView.addSubview(label)
       }
       
       return itemView
   }
   
   // MARK: - Service Offered array format
   func add(stringList: [String],
            font: UIFont,
            bullet: String = "\u{2022}",
            indentation: CGFloat = 20,
            lineSpacing: CGFloat = 2,
            paragraphSpacing: CGFloat = 12,
            textColor: UIColor = .gray,
            bulletColor: UIColor = .red) -> NSAttributedString {
       
       let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
       let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]
       
       let paragraphStyle = NSMutableParagraphStyle()
       let nonOptions = [NSTextTab.OptionKey: Any]()
       paragraphStyle.tabStops = [
           NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
       paragraphStyle.defaultTabInterval = indentation
       //paragraphStyle.firstLineHeadIndent = 0
       //paragraphStyle.headIndent = 20
       //paragraphStyle.tailIndent = 1
       paragraphStyle.lineSpacing = lineSpacing
       paragraphStyle.paragraphSpacing = paragraphSpacing
       paragraphStyle.headIndent = indentation
       
       let bulletList = NSMutableAttributedString()
       for string in stringList {
           let formattedString = "\(bullet)\t\(string)\n"
           let attributedString = NSMutableAttributedString(string: formattedString)
           
           attributedString.addAttributes(
               [NSAttributedString.Key.paragraphStyle : paragraphStyle],
               range: NSMakeRange(0, attributedString.length))
           
           attributedString.addAttributes(
               textAttributes,
               range: NSMakeRange(0, attributedString.length))
           
           let string:NSString = NSString(string: formattedString)
           let rangeForBullet:NSRange = string.range(of: bullet)
           attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
           bulletList.append(attributedString)
       }
       
       return bulletList
   }
   
   // MARK: - Button Action
   //    @objc func blockBtnTapped(sender: UIButton) {
   //        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_USER_REJECT_VC) as! UserRejectServiceViewController
   //        aViewController.gStrProviderId = gStrServiceId
   //        aViewController.gBoolIsFromBlock = true
   //        let width = ModalSize.full
   //        let height = ModalSize.fluid(percentage: 0.50)
   //
   //
   //        let center = ModalCenterPosition.center
   //        let customType = PresentationType.custom(width: width, height: height, center: center)
   //
   //        let customPresenter = Presentr(presentationType: customType)
   //        customPresenter.transitionType = .coverVertical
   //        customPresenter.dismissTransitionType = .coverVertical
   //        customPresenter.roundCorners = true
   //        customPresenter.dismissOnSwipe = true
   //        customPresenter.dismissOnSwipeDirection = .default
   //        customPresenter.blurBackground = false
   //        customPresenter.blurStyle = .extraLight
   //
   //        self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
   //    }
   @objc func favouriteBtnTapped(sender: UIButton) {
       
       
       let aBtnTag = sender.tag
       //        let aStrFav = (myAryUserServices[aBtnTag]["service_favorite"] as? NSString)?.doubleValue
       let aStrFav = myAryUserServices[aBtnTag]["service_favorite"] as? String
       
       if aStrFav == "1" {
           myAryUserServices[aBtnTag]["service_favorite"]  = "0"
       }
       else {
           myAryUserServices[aBtnTag]["service_favorite"] = "1"
       }
       let aStrServiceId = myAryUserServices[aBtnTag]["service_id"]  as! String
       
       let aStrServiceFav = myAryUserServices[aBtnTag]["service_favorite"] as! String
       addRemoveFavouritesApi(serviceID: aStrServiceId, isFav: String(aStrServiceFav) )
       //        let indexPath = IndexPath(item: aBtnTag, section: 1)
       //        self.myTblView.reloadRows(at: [indexPath], with: .none)
       self.myTblView.reloadData()
   }
   @IBAction func mySegmentTapped(_ sender: Any) {
       
       switch mySegmentControl.selectedIndex
       {
       //OverView
       case 0:
           
           myLblNoDataContent.isHidden = true
           myTblView.isHidden = false
           self.myTblView.reloadData()
       //About the Seller
       case 1:
           
           myLblNoDataContent.isHidden = true
           myTblView.isHidden = false
           self.myTblView.reloadData()
       //Reviews
       case 2:
           
           if myAryReviews.count != 0 {
               
               myLblNoDataContent.isHidden = true
               myTblView.isHidden = false
               self.myTblView.reloadData()
           }
           else {
               
               myLblNoDataContent.isHidden = false
               myTblView.isHidden = true
               myLblNoDataContent.text = BookingDetailService.NO_REVIEWS_FOUND.titlecontent()
           }
           
       default:
           break;
       }
   }
   
   @IBAction func btnBookTapped(_ sender: Any) {
       
       if SESSION.getUserToken().count != 0 {
           
           let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_BOOKING_VC) as! NewBookViewController
           aViewController.gStrServiceID = gStrServiceId
           aViewController.gStrServiceAmount = (HELPER.returnStringFromNull(myDictOverView["service_amount"] as AnyObject) as? String)! //(myDictOverView["service_amount"] as? String)!
           self.navigationController?.pushViewController(aViewController, animated: true)
       }
       else {
           
           let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_USER_LOGIN_VC) as! UserLogInViewController
           
           let width = ModalSize.full
           let height = ModalSize.fluid(percentage: 0.50)
           
           //        let width = ModalSize.custom(size: 320)
           //        let height = ModalSize.custom(size: 300)
           
           let center = ModalCenterPosition.center
           let customType = PresentationType.custom(width: width, height: height, center: center)
           
           let customPresenter = Presentr(presentationType: customType)
           customPresenter.transitionType = .coverVertical
           customPresenter.dismissTransitionType = .coverVertical
           customPresenter.roundCorners = true
           customPresenter.dismissOnSwipe = false
           customPresenter.dismissOnSwipeDirection = .default
           customPresenter.blurBackground = false
           customPresenter.blurStyle = .extraLight
           
           self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
       }
   }
   
   @objc func viewonmapbtntapped(sender: UIButton) {
       if CLLocationManager.locationServicesEnabled() {
           switch CLLocationManager.authorizationStatus() {
           case .notDetermined, .restricted, .denied:
               print("No access")
               HELPER.showAlertControllerIn(aViewController: self, aStrMessage: CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent(), okButtonTitle: CommonTitle.ENABLE_LOCATION.titlecontent(), cancelBtnTitle: CommonTitle.NOT_NOW.titlecontent(), okActionBlock: {(sucessAction) in
                   guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                       return
                   }
                   
                   if UIApplication.shared.canOpenURL(settingsUrl) {
                       if #available(iOS 10.0, *) {
                           UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                               print("Settings opened: \(success)") // Prints true
                           })
                       } else {
                           // Fallback on earlier versions
                       }
                   }
               }, cancelActionBlock: { (cancelAction) in
                   
               })
               
           case .authorizedAlways, .authorizedWhenInUse:
               print("Access")
               let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAP_DIRECTION_VC) as! GoogleMapsDirectionViewController
               aViewController.gDestinationLatitude = Double(myStrLatitude)!
               aViewController.gDestinationLongitude = Double(myStrLongitude)!
               aViewController.gProviderName = myStrProviderName
               self.navigationController?.pushViewController(aViewController, animated: true)
               
           }
       } else {
       }
       
       
   }
   
   // MARK: - Api call
   func addRemoveFavouritesApi(serviceID:String, isFav : String) {
       if !HELPER.isConnectedToNetwork() {
           
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
           return
       }
       HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
       var aDictParams = [String:String]()
       aDictParams = ["service_id":serviceID, "status": isFav]
       
       HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_ADD_REMOVE_FAVOURITES,dictParameters:aDictParams, sucessBlock: { response in
           
           HELPER.hideLoadingAnimation()
           
           if response.count != 0 {
               
               let aDictResponse = response[kRESPONSE] as! [String : String]
               let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
               if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                   
                   
               }
               else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                   
                   self.myTblView.reloadData()
                   HELPER.hideLoadingAnimation()
                   //                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
               }
               
               else {
                   HELPER.hideLoadingAnimation()
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
               }
           }
           
       }, failureBlock: { error in
           self.myTblView.reloadData()
           HELPER.hideLoadingAnimation()
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
       })
   }
   func getServiceDetailApi(listId:String) {
       if !HELPER.isConnectedToNetwork() {
           
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
           return
       }
       HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
       
       var aDictParams = [String:String]()
       aDictParams["id"] = listId
       
       HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_SERVICE_DETAIL, dictParameters: aDictParams, sucessBlock: { response in
           
           if response.count != 0 {
               
               var aDictResponse = response[kRESPONSE] as! [String : String]
               
               let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
               
               if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                   
                   var aDictResponseData = [String:Any]()
                   aDictResponseData = response["data"] as! [String:Any]
                   
                   self.myDictOverView = aDictResponseData["service_overview"] as! [String : Any]
                   self.myAryImage = self.myDictOverView["service_image"] as! [String]
                   self.myDictAboutSeller = aDictResponseData["seller_overview"] as! [String : Any]
                   self.myAryUserServices = self.myDictAboutSeller["services"] as! [[String : Any]]
                   self.myAryReviews = aDictResponseData["reviews"] as! [[String : Any]]
                   
                   self.myStrLatitude = self.myDictAboutSeller["latitude"] as! String
                   self.myStrLongitude = self.myDictAboutSeller["longitude"] as! String
                   self.myStrProviderName = self.myDictOverView["service_title"] as! String
                   
                   self.myTblView .reloadData()
                   HELPER.hideLoadingAnimation()
               }
               else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                   HELPER.hideLoadingAnimation()
               }
               else {
                   HELPER.hideLoadingAnimation()
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
               }
           }
           
       }, failureBlock: { error in
           
           HELPER.hideLoadingAnimation()
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
       })
   }
   
   func setServiceViewsApi() {
       
       var aDictParams = [String:String]()
       aDictParams["service_id"] = gStrServiceId
       if !HELPER.isConnectedToNetwork() {
           
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
           return
       }
       HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SERVICE_DETAIL_VIEWS,dictParameters:aDictParams, sucessBlock: { response in
           
           HELPER.hideLoadingAnimation()
           
           if response.count != 0 {
               
               var aDictResponse = response[kRESPONSE] as! [String : String]
               
               //            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
               
               if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                   
                   
                   HELPER.hideLoadingAnimation()
               }
               else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                   
               }
               else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA_500) {
                   
                   
                   HELPER.hideLoadingAnimation()
               }
               else {
                   
                   //                                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
               }
           }
           
       }, failureBlock: { error in
           
           HELPER.hideLoadingAnimation()
           //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
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
   
   func setUpRightBarButton() {
       
       let rightBtn1 = UIButton(type: .custom)
       //        let rightBtn2 = UIButton(type: .custom)
       rightBtn1.setImage(UIImage(named: "icon_home_login_20"), for: .normal)
       //        rightBtn2.setImage(UIImage(named: "icon_search_white_20"), for: .normal)
       
       rightBtn1.addTarget(self, action: #selector(rightBtn1Tapped), for: .touchUpInside)
       //        rightBtn2.addTarget(self, action: #selector(rightBtn2Tapped), for: .touchUpInside)
       
       let rightBarBtnItem1 = UIBarButtonItem(customView: rightBtn1)
       //        let rightBarBtnItem2 = UIBarButtonItem(customView: rightBtn2)
       
       self.navigationItem.rightBarButtonItems = [rightBarBtnItem1]
   }
   
   @objc func rightBtn1Tapped() {
       
       let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_PROVIDER_LOGIN_VC) as! ProviderLogInViewController
       
       let width = ModalSize.full
       let height =  ModalSize.full//ModalSize.fluid(percentage: 0.50)
       
       let center = ModalCenterPosition.center
       let customType = PresentationType.custom(width: width, height: height, center: center)
       
       let customPresenter = Presentr(presentationType: customType)
       customPresenter.transitionType = .coverVertical
       customPresenter.dismissTransitionType = .coverVertical
       customPresenter.roundCorners = true
       customPresenter.dismissOnSwipe = false
       customPresenter.dismissOnSwipeDirection = .default
       customPresenter.blurBackground = false
       customPresenter.blurStyle = .extraLight
       
       self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
   }
   
}


