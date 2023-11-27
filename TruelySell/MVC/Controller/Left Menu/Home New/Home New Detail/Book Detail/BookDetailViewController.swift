 

import UIKit
import MXSegmentedControl
import AARatingBar
import Presentr
import CoreLocation

class BookDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,iCarouselDataSource,iCarouselDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var myBtnComplete: UIButton!
    @IBOutlet weak var myBtnNotComplete: UIButton!
    @IBOutlet weak var myViewReject: UIView!
    @IBOutlet weak var myViewComplete: UIView!
    @IBOutlet weak var myViewRejectBn: UIView!
    @IBOutlet weak var myViewAcceptBtn: UIView!
    @IBOutlet weak var myBtnRejectRequest: UIButton!
    @IBOutlet weak var myBtnAcceptRequest: UIButton!
    @IBOutlet weak var myContainerViewDualButton: UIView!
    @IBOutlet weak var mySegmentControl: MXSegmentedControl!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myConstraintHeightNotCompleted: NSLayoutConstraint!
    @IBOutlet weak var myConstraintHeightCompleted: NSLayoutConstraint!
    @IBOutlet weak var myConstraintHeightDualButton: NSLayoutConstraint!
    @IBOutlet weak var myConstraintHeightTopView: NSLayoutConstraint!
    @IBOutlet weak var myConstraintHeightSingleBtn: NSLayoutConstraint!
    
    
    @IBOutlet weak var myViewTop: UIView!
    @IBOutlet weak var myViewColor: UIView!
    @IBOutlet weak var myViewSingleBottom: UIView!
    @IBOutlet weak var myContainerViewSingleButton: UIView!
    @IBOutlet weak var myBtnSingleBtnBottom: UIButton!
    @IBOutlet weak var myLblMarkAsComplete: UILabel!
    
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
    let cellTableViewBookingDescriptionIdentifier = "HomeDetailOverviewViewServiceDetailBookingInfoDescriptionTableViewCell"
    
    //About Seller
    let cellTableDetailSellerHeaderIdentifier = "HomeDetailSellerHeaderTableViewCell"
    let cellTableDetailSellerFirstIdentifier = "HomeDetailSellerProfileTableViewCell"
    let cellTableDetailSellerSecondIdentifier = "HomeDetailSellerLocationTableViewCell"
    let cellTableDetailSellerThirdIdentifier = "HomeNewCollectionViewTableViewCell"
    
    //Booking Info
    let cellTableDetailBookingInfoFirstIdentifier = "NewBookingDetailTimeslotTableViewCell"
    
    //Temp
    let cellTableViewAllListIdentifier = "ViewAllListTableViewCell"
    
    var myDictOverView = [String:Any]()
    var myDictAboutSeller = [String:Any]()
    var myDictReviews = [String:String]()
    var myAryUserServices = [[String:Any]]()
    
    var myStrIsCod = String()
    //temp
    
    var myAryImage: [String] = []
    var gStrBlockingProvUserId = String()
    var gStrServiceId = String()
    var myStrStatusId = String()
    var myStrBookingId = String()
    
    var myStrLatitude = String()
    var myStrLongitude = String()
    var myStrProviderName = String()
    var myStrAvailability = String()
    
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
        
        callAccountStatusApi()
        getServiceDetailApi(listId: gStrServiceId)
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: Booking_service.SERVICE_DETAIL.titlecontent(), aViewController: self)
        
        setUpLeftBarBackButton()
        myLblMarkAsComplete.text = Booking_service.MARK_AS_COMPLETE.titlecontent()
        mySegmentControl.append(title: BookingDetailService.OVERVIEW.titlecontent())
        if SESSION.getUserLogInType() == "2" {
            mySegmentControl.append(title: BookingDetailService.ABOUT_SELLER.titlecontent())
        }else {
            mySegmentControl.append(title: BookingDetailService.ABOUTBUYER.titlecontent())
        }
    
        mySegmentControl.append(title: BookingDetailService.BOOKINGINFO.titlecontent())
        mySegmentControl.font =  UIFont.systemFont(ofSize: 14)
        mySegmentControl.indicatorColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        mySegmentControl.selectedTextColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        myViewAcceptBtn.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myViewRejectBn.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myContainerViewSingleButton.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        HELPER.setRoundCornerView(aView: myViewColor, borderRadius: 5.0)
        HELPER.setRoundCornerView(aView: myContainerViewSingleButton, borderRadius: 15.0)
        
        myContainerViewDualButton.isHidden = true
        myViewTop.isHidden = true
        myViewSingleBottom.isHidden = true
        
        myConstraintHeightDualButton.constant = 0
        myConstraintHeightSingleBtn.constant = 0
        myConstraintHeightTopView.constant = 0
        
        myBtnAcceptRequest.setTitle(BookingDetailService.ACCEPTREQUEST.titlecontent(), for: .normal)
        myBtnRejectRequest.setTitle(BookingDetailService.REJECTREQUEST.titlecontent(), for: .normal)
        //        myBtnSingleBtnBottom.setTitle("Rate Now", for: .normal)
        
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
        
        //Booking Info
        myTblView.register(UINib.init(nibName: cellTableDetailBookingInfoFirstIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDetailBookingInfoFirstIdentifier)
        myTblView.register(UINib.init(nibName: cellTableViewBookingDescriptionIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewBookingDescriptionIdentifier)
        //Temp
        myTblView.register(UINib.init(nibName: cellTableViewAllListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewAllListIdentifier)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    // MARK: - Table View delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if mySegmentControl.selectedIndex == 1 {
            
            return 2
        }
        else if mySegmentControl.selectedIndex == 2 {
            if myDictReviews["admin_comments"] == "" && myDictReviews["user_rejected_reason"] == "" {
                return 2
            }
            else if myDictReviews["user_rejected_reason"] == "" && myDictReviews["admin_comments"] != "" {
                return 3
            }
            else if myDictReviews["user_rejected_reason"] != "" && myDictReviews["admin_comments"] == "" {
                return 3
            }
            else {
                return 4
            }
            
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
            
            return 1
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
        else if mySegmentControl.selectedIndex == 2 {
            
            return 50
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
                
                return 150
            }
            else if indexPath.section == 1 {
                
                return 60
            }
            else {
                
                return 150
            }
        }
        else {
            
            if indexPath.section == 0 {
                
                return 150
            }
            else if indexPath.section == 1 {
                if myDictReviews["notes"] == "" {
                    return 40
                }
                else {
                    
                    return UITableView.automaticDimension
                }
                
            }
            else if indexPath.section == 2 {
                if myDictReviews["admin_comments"] == "" {
                    return 40
                }
                else if myDictReviews["user_rejected_reason"] == "" {
                    return 40
                }
                else {
                    return UITableView.automaticDimension
                }
            }
            else{
                if myDictReviews["admin_comments"] == "" {
                    return 40
                }
                else {
                    
                    return UITableView.automaticDimension
                }
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if mySegmentControl.selectedIndex == 1 {
            
            var aCell:HomeDetailSellerHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableDetailSellerHeaderIdentifier) as? HomeDetailSellerHeaderTableViewCell
            
            HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell?.gImgMapLocation, imageName: "icon_map_view_all")
            
            aCell?.gBtnViewOnMap.tag = section
            aCell?.gLblViewOnMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell?.gLblViewOnMapContent.text = ViewAllServices.VIEW_ON_MAP.titlecontent()
            
            aCell?.backgroundColor = UIColor.clear
            
            if  (aCell == nil) {
                
                let nib:NSArray=Bundle.main.loadNibNamed(cellTableDetailSellerHeaderIdentifier, owner: self, options: nil)! as NSArray
                aCell = nib.object(at: 0) as? HomeDetailSellerHeaderTableViewCell
            }
            
            else {
                
                if section == 1 {
                    
                    aCell?.gLblHeader.text = BookingDetailService.LOCATION.titlecontent()
                    aCell?.gBtnViewOnMap.isHidden = false
                    aCell?.gBtnViewOnMap.addTarget(self, action: #selector(self.viewonmapbtntapped(sender:)), for: .touchUpInside)
                }
                
                aCell?.gViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
                HELPER.setRoundCornerView(aView: aCell!.gViewColor, borderRadius: 2.5)
            }
            
            aCell?.gViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            //            HELPER.setRoundCornerView(aView: aCell!.gViewColor, borderRadius: 2.5)
            
            return aCell
        }
        else if mySegmentControl.selectedIndex == 2 {
            
            var aCell:HomeDetailSellerHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableDetailSellerHeaderIdentifier) as? HomeDetailSellerHeaderTableViewCell
            HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell?.gImgMapLocation, imageName: "icon_map_view_all")
            aCell?.gBtnViewOnMap.tag = section
            aCell?.gLblViewOnMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell?.gLblViewOnMapContent.text = ViewAllServices.VIEW_ON_MAP.titlecontent()
            
            //        aCell?.gBtnViewAll.addTarget(self, action: #selector(self.filterBtnTapped(sender:)), for: .touchUpInside)
            
            aCell?.backgroundColor = UIColor.clear
            
            if  (aCell == nil) {
                
                let nib:NSArray=Bundle.main.loadNibNamed(cellTableDetailSellerHeaderIdentifier, owner: self, options: nil)! as NSArray
                aCell = nib.object(at: 0) as? HomeDetailSellerHeaderTableViewCell
            }
            
            else {
                
                if section == 0 {
                    
                    aCell?.gLblHeader.text = BookingDetailService.APPOINMENT_SLOT.titlecontent()
                }
                else if section == 1 {
                    
                    aCell?.gLblHeader.text = BookingDetailService.MESSAGE_FROM_BUYER.titlecontent()
                }
                else if section == 2 {
                    if myDictReviews["user_rejected_reason"] == "" && myDictReviews["admin_comments"] != "" {
                        aCell?.gLblHeader.text = BookingDetailService.ADMIN_COMMENTS.titlecontent()
                    }
                    else {
                        aCell?.gLblHeader.text = BookingDetailService.REJECTED_REASON.titlecontent()
                    }
                }
                else if section == 3 {
                    
                    aCell?.gLblHeader.text = BookingDetailService.ADMIN_COMMENTS.titlecontent()
                }
                aCell?.gContainerViewOnMap.isHidden = true
                
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
                    
                    let aStrCurrency = HELPER.returnStringFromNull(myDictOverView["currency_code"] as AnyObject) as? String  //myDictOverView["currency_code"] as? String
                    let aStrAmount = HELPER.returnStringFromNull(myDictOverView["service_amount"] as AnyObject) as? String  //myDictOverView["service_amount"] as? String
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gLblPrice.textAlignment = .left
                    }
                    else {
                        aCell.gLblPrice.textAlignment = .right
                    }
                    aCell.gLblPrice.text = aStrCurrency!.html2String + aStrAmount!
                    aCell.gLblServiceName.text = HELPER.returnStringFromNull(myDictOverView["service_title"] as AnyObject) as? String  //myDictOverView["service_title"] as? String
                    aCell.gLblViews.text = (HELPER.returnStringFromNull(myDictOverView["total_views"] as AnyObject) as? String)! + BookingDetailService.VIEWS.titlecontent()
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
                    
                    aCell.gLblCategory.text = HELPER.returnStringFromNull(myDictOverView["category_name"] as AnyObject) as? String  //myDictOverView["category_name"] as? String
                    aCell.gViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    HELPER.setRoundCornerView(aView: aCell.gViewCategory, borderRadius: 15.0)
                    
                    let aStrRatingCount:String = (myDictOverView["rating_count"] as? String)!
                    
                    aCell.gLblRating.text = "(" + aStrRatingCount + ")"
                    
                    let aStrRatingValue:String = (HELPER.returnStringFromNull(myDictOverView["rating"] as AnyObject) as? String)!  //(myDictOverView["rating"] as? String)!
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
                aCell.gLblDescription.text = HELPER.returnStringFromNull(myDictOverView["about"] as AnyObject) as? String  //myDictOverView["about"] as? String
                
                return aCell
            }
            else {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailOverViewThirdIdentifier, for: indexPath) as! HomeDetailOverViewDescriptionTableViewCell
                
                aCell.gLblDescriptionContent.text = BookingDetailService.SERVICE_OFFERED.titlecontent()
                
                if myDictOverView.count != 0 {
                    let aStrJson = HELPER.returnStringFromNull(myDictOverView["service_offered"] as AnyObject) as? String  //myDictOverView["service_offered"] as? String
                    
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
                
                aCell.gViewChatCallWidthConstraint.constant = 100
                aCell.gImgViewCall.isHidden = false
                aCell.gImgViewChat.isHidden = false
                HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView:  aCell.gImgViewChat, imageName: "icon_new_chat")
                HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView:  aCell.gImgViewCall, imageName: "icon_new_call")
                
                let aStrUserImg: String = HELPER.returnStringFromNull(myDictAboutSeller["profile_img"] as AnyObject) as! String  //myDictAboutSeller["profile_img"]! as! String
                let aStrCountryCode: String = HELPER.returnStringFromNull(myDictAboutSeller["country_code"] as AnyObject) as! String  //myDictAboutSeller["country_code"]! as! String
                let aStrMobNo: String = HELPER.returnStringFromNull(myDictAboutSeller["mobileno"] as AnyObject) as! String  //myDictAboutSeller["mobileno"]! as! String
                
                aCell.gLblName.text = HELPER.returnStringFromNull(myDictAboutSeller["name"] as AnyObject) as! String  //myDictAboutSeller["name"] as? String
                aCell.gLblEmail.text = HELPER.returnStringFromNull(myDictAboutSeller["email"] as AnyObject) as! String  //myDictAboutSeller["email"] as? String
                aCell.gLblMobNumb.text = aStrCountryCode + " " + aStrMobNo
                
                aCell.gBtnCall.addTarget(self, action: #selector(self.callBtnTapped(sender:)), for: .touchUpInside)
                aCell.gBtnChat.addTarget(self, action: #selector(self.chatBtnTapped(sender:)), for: .touchUpInside)
                aCell.gViewBlock.isHidden = true
                aCell.gViewBlock.backgroundColor = UIColor.red
                aCell.gViewBlock.layer.masksToBounds = true
                aCell.gViewBlock.clipsToBounds = true
                aCell.gViewBlock.layer.cornerRadius = aCell.gViewBlock.frame.size.height / 2
                aCell.gBtnBlock.setTitle(Booking_service.BLOCK.titlecontent(), for: .normal)
                aCell.gImgViewProfilePic.setShowActivityIndicator(true)
                aCell.gImgViewProfilePic.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                aCell.gImgViewProfilePic.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                aCell.gBtnBlock.addTarget(self, action: #selector(blockBtnTapped), for: .touchUpInside)
                
                return aCell
            }
            else if indexPath.section == 1 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailSellerSecondIdentifier, for: indexPath) as! HomeDetailSellerLocationTableViewCell
                
                aCell.gLblLocation.text = HELPER.returnStringFromNull(myDictAboutSeller["location"] as AnyObject) as? String //myDictAboutSeller["location"] as? String
                
                return aCell
            }
            else {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailSellerThirdIdentifier, for: indexPath) as! HomeNewCollectionViewTableViewCell
                
                aCell.gCategoryCollectionView.delegate = self
                aCell.gCategoryCollectionView.dataSource = self
                aCell.gCategoryCollectionView.tag = indexPath.section
                aCell.gViewEnableLocationContainer.isHidden = true
                aCell.gCategoryCollectionView.register(UINib(nibName: cellServiceListCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellServiceListCollectionIdentifier)
                
                aCell.gCategoryCollectionView.reloadData()
                return aCell
            }
            
        }
        else { // Comments
            
            if indexPath.section == 0 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailBookingInfoFirstIdentifier, for: indexPath) as! NewBookingDetailTimeslotTableViewCell
                
                aCell.gLblBookedDate.text = myDictReviews["service_date"]
                if WEB_TIME_FORMAT == "hh:mm a" {
                    aCell.gLblFromTime.text = myDictReviews["from_time"]
                    aCell.gLblToTime.text = myDictReviews["to_time"]
                } else {
                    let dateAsString = myDictReviews["from_time"]
                    let date2AsString = myDictReviews["to_time"]
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"

                    let date = dateFormatter.date(from: dateAsString!)
                    let date2 = dateFormatter.date(from: date2AsString!)
                    dateFormatter.dateFormat = "HH:mm"

                    let Date1 = dateFormatter.string(from: date!)
                    let Date2 = dateFormatter.string(from: date2!)
                    aCell.gLblFromTime.text = Date1
                    aCell.gLblToTime.text = Date2
                }
               
//                if self.myStrStatusId == "1" {
//                    aCell.myViewRescheduleContainer.isHidden = false
//                    aCell.gRescheduleHeightConstraints.constant = 40
//                }
//                else {
//                    aCell.myViewRescheduleContainer.isHidden = true
//                    aCell.gRescheduleHeightConstraints.constant = 0
//                }
                aCell.gRescheduleHeightConstraints.constant = 0
                aCell.myViewRescheduleContainer.isHidden = true
                aCell.myBtnReschedule.setTitle(BookingDetailService.RESCHEDULE.titlecontent(), for: .normal)
                aCell.myBtnReschedule.tag = indexPath.row
                aCell.myBtnReschedule.addTarget(self, action: #selector(rescheduleBtnTapped(sender:)), for: .touchUpInside)
                aCell.myViewRescheduleContainer.layer.cornerRadius = aCell.myViewRescheduleContainer.layer.frame.height / 2
                aCell.myViewRescheduleContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                
                //RTL
                aCell.gLblTitleToTime.text = BookingDetailService.TO_TIME.titlecontent()
                aCell.gLblTitleToTime.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gLblTitleFromTime.text = BookingDetailService.FROM_TIME.titlecontent()
                 aCell.gLblTitleFromTime.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                return aCell
            }
            else if indexPath.section == 1 {
                
                //                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDetailOverViewThirdIdentifier, for: indexPath) as! HomeDetailOverViewDescriptionTableViewCell
                
                //                aCell.gLblDescriptionContent.text = "Description:"
                //                aCell.gLblDescription.text = myDictReviews["notes"] as? String
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableViewBookingDescriptionIdentifier, for: indexPath) as! HomeDetailOverviewViewServiceDetailBookingInfoDescriptionTableViewCell
                aCell.myLblDescription.text = myDictReviews["notes"]
                return aCell
            }
            else if indexPath.section == 2 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableViewBookingDescriptionIdentifier, for: indexPath) as! HomeDetailOverviewViewServiceDetailBookingInfoDescriptionTableViewCell
                if myDictReviews["user_rejected_reason"] == "" && myDictReviews["admin_comments"] != "" {
                    aCell.myLblDescription.text = myDictReviews["admin_comments"]
                }
                else {
                    aCell.myLblDescription.text = myDictReviews["user_rejected_reason"]
                }
                return aCell
            }
            else {
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableViewBookingDescriptionIdentifier, for: indexPath) as! HomeDetailOverviewViewServiceDetailBookingInfoDescriptionTableViewCell
                aCell.myLblDescription.text = myDictReviews["admin_comments"]
                return aCell
            }
        }
    }
    
    // MARK: - Collection View Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myAryUserServices.count == 0 ? 0 : myAryUserServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellServiceListCollectionIdentifier, for: indexPath) as! ServiceListNewCollectionViewCell
        
        HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 20.0)
        
        HELPER.setRoundCornerView(aView: aCell.gContainerViewUserImage)
        HELPER.setRoundCornerView(aView: aCell.gImgViewUserImage)
        
        HELPER.setRoundCornerView(aView: aCell.gContainerViewUserImage)
        HELPER.setRoundCornerView(aView: aCell.gContainerViewCategory, borderRadius: 10.0)
      
//        aCell.gViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        aCell.gContainerViewUserImage.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
//
        aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
//
//        HELPER.setRoundCornerView(aView: aCell.gViewColor, borderRadius: 2.5)
        
        if myAryUserServices.count != 0 {
            
            let aStrUserImg: String = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["service_image"] as AnyObject) as! String //myAryUserServices[indexPath.row]["service_image"]! as! String
            let aStrRatingCount: String = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["rating_count"] as AnyObject) as! String //myAryUserServices[indexPath.row]["rating_count"]! as! String
            let aStrCurrency = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["rating_count"] as AnyObject) as! String //(myAryUserServices[indexPath.row]["currency"] as? String)!
            let aStrAmount = (HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["service_amount"] as AnyObject) as? String)! // (myAryUserServices[indexPath.row]["service_amount"] as? String)!
            
            aCell.gImgViewUserImage.setShowActivityIndicator(true)
            aCell.gImgViewUserImage.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewUserImage.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: ICON_PLACEHOLDER_SQUARE))
            
            aCell.gImgViewServiceList.setShowActivityIndicator(true)
            aCell.gImgViewServiceList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewServiceList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: nil)
            
            aCell.gLblServiceName.text = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["service_title"] as AnyObject) as? String //myAryUserServices[indexPath.row]["service_title"] as? String
            aCell.gLblCategoryName.text = HELPER.returnStringFromNull(myAryUserServices[indexPath.row]["category_name"] as AnyObject) as? String //myAryUserServices[indexPath.row]["category_name"] as? String
            aCell.gLblRateCount.text = "(" + aStrRatingCount + ")"
            aCell.gLblPrice.text = aStrCurrency.html2String + aStrAmount
            aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            if SESSION.getUserToken().count == 0 {
                aCell.gBtnFav.isHidden = true
            }
            else {
                aCell.gBtnFav.isHidden = false
                //                if (myAryUserServices[indexPath.row]["service_favorite"] as? NSString)?.doubleValue == 1 {
                if myAryUserServices[indexPath.row]["service_favorite"] as? Int == 1 {
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
        
        return CGSize(width: 250, height: 180)
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
    @IBAction func rescheduleBtnTapped(sender: UIButton) {
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_BOOKING_VC) as! NewBookViewController
        aViewController.gBoolIsFromReschedule = true
        aViewController.myStrSelectedDate = myDictReviews["service_date"]!
        aViewController.gStrServiceID = self.myStrBookingId
        aViewController.gStrNotes = myDictReviews["notes"]!
        aViewController.gStrBookingID = myDictReviews["booking_id"]!
        self.navigationController?.pushViewController(aViewController, animated: true)
        
    }
    @objc func favouriteBtnTapped(sender: UIButton) {
        
        
        let aBtnTag = sender.tag
        //        let aStrFav = (myAryUserServices[aBtnTag]["service_favorite"] as? NSString)?.doubleValue
        let aStrFav = myAryUserServices[aBtnTag]["service_favorite"] as? Int
        if aStrFav == 1 {
            myAryUserServices[aBtnTag]["service_favorite"]  = 0
        }
        else {
            myAryUserServices[aBtnTag]["service_favorite"] = 1
        }
        let aStrServiceId = myAryUserServices[aBtnTag]["service_id"]  as! String
        
        let aStrServiceFav = myAryUserServices[aBtnTag]["service_favorite"] as! Int
        addRemoveFavouritesApi(serviceID: aStrServiceId, isFav: String(aStrServiceFav) )
        let indexPath = IndexPath(item: aBtnTag, section: 0)
        self.myTblView.reloadRows(at: [indexPath], with: .none)
        
    }
    @IBAction func mySegmentTapped(_ sender: Any) {
        
        switch mySegmentControl.selectedIndex
        {
        //OverView
        case 0:
            
            self.myTblView.reloadData()
        //About the Seller
        case 1:
            
            self.myTblView.reloadData()
        //Reviews
        case 2:
            
            self.myTblView.reloadData()
        default:
            break;
        }
    }
    @IBAction func btnAcceptTapped(_ sender: Any) {
        setServiceStatusApi(statusType: "1")
        
        //        if myStrAvailability.count != 0 {
        //
        //            if myStrAvailability == "1" {
        //
        //               setServiceStatusApi(statusType: "1")
        //            }
        //            else {
        //
        //                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: "Update Account Details in Settings to Book a Service", okActionBlock: { (action) in
        //
        //                    let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PAYMENT_SETTINGS_VC) as! PaymentSettingsViewController
        //                    self.navigationController?.pushViewController(aViewController, animated: true)
        //                })
        //            }
        //        }
    }
    
    @IBAction func btnRejectTapped(_ sender: Any) {
        
        setServiceStatusApi(statusType: "5")
    }
    @objc func blockBtnTapped(sender: UIButton) {
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_USER_REJECT_VC) as! UserRejectServiceViewController
        aViewController.gStrProviderUSerId = gStrBlockingProvUserId
        aViewController.gBoolIsFromBlock = true
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 0.50)
        
        
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .default
        customPresenter.blurBackground = false
        customPresenter.blurStyle = .extraLight
        
        self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnNotCompleteTapped(_ sender: Any) {
      
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_USER_REJECT_VC) as! UserRejectServiceViewController
        aViewController.gStrServiceId = gStrServiceId
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
    
    @IBAction func btnCompleteTapped(_ sender: Any) {
        
        let aUserType:String = SESSION.getUserLogInType()
        
        if aUserType == "1" {
            if self.myStrStatusId == "6" && self.myStrIsCod == "1" {
                setServiceStatusApi(statusType: "8")
            }
            else {
            setServiceStatusApi(statusType: "3")
            }
        }
        else {
            
            setServiceStatusApi(statusType: "4")
        }
    }
    
    @IBAction func btnSingleBottomTapped(_ sender: Any) {
        
        if self.myStrStatusId == "1" { //Cancel option // in api send 2
            
            setServiceStatusApi(statusType: "2")
        }
        else {
            
            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_RATE_NOW_VC) as! RateNowViewController
            aViewController.gStrProviderID = gStrServiceId
            aViewController.gStrBookingID = myStrBookingId
            self.navigationController?.pushViewController(aViewController, animated: true)
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
    
    @objc func callBtnTapped(sender: UIButton) {
        
        if let phoneno = myDictAboutSeller["mobileno"] as? String {
            guard let number = URL(string: "tel://" + phoneno) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func chatBtnTapped(sender: UIButton) {
        
        let aViewController:ChatDetailViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHAT_DETAIL) as! ChatDetailViewController
        aViewController.gStrToUserId = HELPER.returnStringFromNull(myDictAboutSeller["token"] as AnyObject) as? String ?? "" //myDictAboutSeller["token"]  as? String ?? ""
        aViewController.gStrUserName = HELPER.returnStringFromNull(myDictAboutSeller["name"] as AnyObject) as? String ?? "" //myDictAboutSeller["name"] as? String ?? ""
        aViewController.gStrUserProfImg = HELPER.returnStringFromNull(myDictAboutSeller["profile_img"] as AnyObject) as? String ?? "" //myDictAboutSeller["profile_img"] as? String ?? ""
        self.navigationController?.pushViewController(aViewController, animated: true)
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
        aDictParams["booking_id"] = listId
        aDictParams["type"] = SESSION.getUserLogInType()
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BOOKING_DETAIL, dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    
                    var aStrRateCount = String()
                    if aDictResponseData.count != 0 {
                        self.myDictOverView = aDictResponseData["service_details"] as! [String : Any]
                        self.myAryImage = self.myDictOverView["service_image"] as! [String]
                        self.myDictAboutSeller = aDictResponseData["personal_details"] as! [String : Any]
                       
                        //                self.myAryUserServices = self.myDictAboutSeller["services"] as! [[String : Any]]
                        self.myDictReviews = aDictResponseData["booking_details"] as! [String : String]
                        self.myStrIsCod = self.myDictReviews["cod"] ?? ""
                        if SESSION.getUserLogInType() == "1" {
                            self.gStrBlockingProvUserId = self.myDictReviews["user_id"]!
                        } else {
                            self.gStrBlockingProvUserId = self.myDictReviews["provider_id"]!
                        }
                        
                        self.myStrStatusId = self.myDictReviews["status"]!
                        aStrRateCount = self.myDictOverView["is_rated"] as! String
                        self.myStrBookingId = self.myDictOverView["service_id"] as! String
                        //                myContainerViewDualButton.isHidden = true
                        //                myViewTop.isHidden = true
                        
                        self.myStrLatitude = self.myDictAboutSeller["latitude"] as! String
                        self.myStrLongitude = self.myDictAboutSeller["longitude"] as! String
                        self.myStrProviderName = self.myDictOverView["service_title"] as! String
                        
                        if self.myStrStatusId.count != 0 {
                            
                            if SESSION.getUserLogInType() == "1" {
                                
                                if self.myStrStatusId == "1" {
                                    
                                    self.myContainerViewDualButton.isHidden = false
                                    self.myViewTop.isHidden = true
                                    self.myViewSingleBottom.isHidden = true
                                    
                                    self.myConstraintHeightDualButton.constant = 50
                                    self.myConstraintHeightSingleBtn.constant = 0
                                    self.myConstraintHeightTopView.constant = 0
                                    self.myConstraintHeightNotCompleted.constant = 0
                                    self.myConstraintHeightCompleted.constant = 0
                                }
                                else if self.myStrStatusId == "2" {
                                    
                                    self.myViewTop.isHidden = false
                                    self.myContainerViewDualButton.isHidden = true
                                    self.myViewSingleBottom.isHidden = true
                                    self.myConstraintHeightNotCompleted.constant = 0
                                    self.myConstraintHeightCompleted.constant = 30
                                    self.myConstraintHeightDualButton.constant = 0
                                    self.myConstraintHeightSingleBtn.constant = 0
                                    self.myConstraintHeightTopView.constant = 50
                                }
                                else if self.myStrStatusId == "6" && self.myStrIsCod == "1" {
                                    self.myViewTop.isHidden = false
                                    self.myContainerViewDualButton.isHidden = true
                                    self.myViewSingleBottom.isHidden = true
                                    self.myLblMarkAsComplete.text = Booking_service.COD_RECEIVED.titlecontent()
                                    self.myConstraintHeightNotCompleted.constant = 0
                                    self.myConstraintHeightCompleted.constant = 30
                                    self.myConstraintHeightDualButton.constant = 0
                                    self.myConstraintHeightSingleBtn.constant = 0
                                    self.myConstraintHeightTopView.constant = 50
                                }
                            }
                            else { // User
                                
                                if self.myStrStatusId == "1" { //Cancel option // in api send 2
                                    
                                    self.myViewTop.isHidden = true
                                    self.myViewSingleBottom.isHidden = false
                                    self.myContainerViewDualButton.isHidden = true
                                    self.myBtnSingleBtnBottom.setTitle(ProviderAndUserScreenTitle.BTN_CANCEL.titlecontent(), for: .normal)
                                    self.myConstraintHeightTopView.constant = 0
                                    self.myConstraintHeightNotCompleted.constant = 0
                                    self.myConstraintHeightCompleted.constant = 0
                                    self.myConstraintHeightDualButton.constant = 0
                                    self.myConstraintHeightSingleBtn.constant = 50
                                }
                                else if self.myStrStatusId == "3" {
                                    
                                    self.myViewTop.isHidden = false
                                    self.myContainerViewDualButton.isHidden = true
                                    self.myViewSingleBottom.isHidden = true
                                    
                                    self.myConstraintHeightTopView.constant = 50
                                    self.myConstraintHeightNotCompleted.constant = 30
                                    self.myConstraintHeightCompleted.constant = 30
                                    self.myConstraintHeightDualButton.constant = 0
                                    self.myConstraintHeightSingleBtn.constant = 0
                                }
                                else if self.myStrStatusId == "8" && aStrRateCount == "0" {
                                    
                                    self.myViewTop.isHidden = true
                                    self.myViewSingleBottom.isHidden = false
                                    self.myContainerViewDualButton.isHidden = true
                                    self.myBtnSingleBtnBottom.setTitle(BookingDetailService.RATE_NOW.titlecontent(), for: .normal)
                                    self.myConstraintHeightTopView.constant = 0
                                    self.myConstraintHeightNotCompleted.constant = 0
                                    self.myConstraintHeightCompleted.constant = 0
                                    self.myConstraintHeightDualButton.constant = 0
                                    self.myConstraintHeightSingleBtn.constant = 50
                                }
                                else if self.myStrStatusId == "6" && aStrRateCount == "0" {
                                    
                                    self.myViewTop.isHidden = true
                                    if self.myStrIsCod == "1" {
                                        self.myViewSingleBottom.isHidden = true
                                    }
                                    else {
                                        self.myViewSingleBottom.isHidden = false
                                    }
                                    self.myContainerViewDualButton.isHidden = true
                                    self.myBtnSingleBtnBottom.setTitle(BookingDetailService.RATE_NOW.titlecontent(), for: .normal)
                                    self.myConstraintHeightTopView.constant = 0
                                    self.myConstraintHeightNotCompleted.constant = 0
                                    self.myConstraintHeightCompleted.constant = 0
                                    self.myConstraintHeightDualButton.constant = 0
                                    self.myConstraintHeightSingleBtn.constant = 50
                                }
                            }
                        }
                        
                        self.myTblView .reloadData()
                    }
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
    
    //Change Status
    func setServiceStatusApi(statusType:String) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        if statusType == "5" {
            
            aDictParams["id"] = gStrServiceId
            aDictParams["type"] = SESSION.getUserLogInType()
            aDictParams["status"] = statusType
            aDictParams["reason"] = ""
        }
        else if statusType == "2" {
            
            aDictParams["id"] = gStrServiceId
            aDictParams["type"] = SESSION.getUserLogInType()
            aDictParams["status"] = statusType
        }
        else if statusType == "8"  {
            
            aDictParams["id"] = gStrServiceId
            aDictParams["type"] = SESSION.getUserLogInType()
            aDictParams["status"] = statusType
        }
        else {
            
            aDictParams["id"] = gStrServiceId
            aDictParams["type"] = SESSION.getUserLogInType()
            aDictParams["status"] = statusType
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BOOKING_STATUS_UPDATE, dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                    
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
    
    func callAccountStatusApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["type"] = SESSION.getUserLogInType()
        
        HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_CHECK_STATUS, dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.hideLoadingAnimation()
                    var aDictResponse = response["data"] as! [String : String]
                    self.myStrAvailability = aDictResponse["account_details"]!
                }
                else {
                    
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
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
        
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_USER_LOGIN_VC) as! UserLogInViewController
        aViewController.isFromTabbar = true
        let width = ModalSize.full
        let height =  ModalSize.full //ModalSize.fluid(percentage: 0.50) //ModalSize.half //
        
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
        //        customPresenter.backgroundTap = .noAction
        self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
    }
    
}


