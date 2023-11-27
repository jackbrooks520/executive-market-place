 
import UIKit
import MXSegmentedControl
import GoogleMaps
import GooglePlaces
import FSCalendar
import Stripe
//import FormTextField

protocol calendarDelegate {
    func calendarDelegateMethod()
}

class NewBookViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FSCalendarDelegate,FSCalendarDataSource,UIGestureRecognizerDelegate,GMSMapViewDelegate,UITextViewDelegate,UITextFieldDelegate {
    
    lazy var mapView = GMSMapView()
    var locationManager = CLLocationManager()
    var centerMapCoordinate:CLLocationCoordinate2D!
    var myDictWalletInfo = [String:Any]()
    
    
    @IBOutlet weak var mySearchLocation: UISearchBar!
    @IBOutlet weak var myViewTimeandDate: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mySegmentControl: MXSegmentedControl!
    @IBOutlet weak var myViewPrevious: UIView!
    @IBOutlet weak var myViewNext: UIView!
    @IBOutlet weak var myButtonPrevious: UIButton!
    @IBOutlet weak var myBtnNext: UIButton!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myLblLocName: UILabel!
    @IBOutlet weak var myLblNoTimeContent: UILabel!

    @IBOutlet weak var myViewMap: UIView!
    //Calender
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var calendarView: FSCalendar!
    var calendarDel : calendarDelegate!
    
    @IBOutlet weak var myViewSingleButton: UIView!
    @IBOutlet weak var myViewDualButton: UIView!
    @IBOutlet weak var myContinerViewSingleButton: UIView!
    @IBOutlet weak var myBtnSingle: UIButton!
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: calendarView, action: #selector(calendarView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    //Cells
    let cellTableHeaderIdentifier = "HomeNewHeaderTableViewCell"
    let cellTableDescriptionIdentifier = "NewBookNowDescriptionTableViewCell"
    let cellTablePaymentIdentifier = "NewBookNowPaymentTableViewCell"
    let walletTopupCurrentBalanceCellIdentifier: String = "WalletTopupCurrentBalanceTableViewCell"
    
    let PaymentMethodIdentifier = "PaymentMethodTableViewCell"
    let cellCollectionTimeandDateIdentifier = "NewBookNowTimeDateListCollectionViewCell"
    
    var myAryTimeInfo = [[String:Any]]()
    var myStrSelectedDate = String()
    var myStrFromTime = String()
    var myStrToTime = String()
    var myStrNote = String()
    var myStrCardNo = String()
    var myStrCardCvv = String()
    var myStrCardExp = String()
    var myStrLocName = String()
    var myStrLat = String()
    var myStrLong = String()
    var myStrDescription = String()
    var myStrAccountCheck = String()
    
    var gStrServiceID = String()
    var gStrServiceAmount = String()
     var gStrBookingID = String()
    var gStrNotes = String()
    var gBoolIsFromReschedule = Bool()
    
    
    var myStrPaymentmethod: String = "2"
    let TAG_DESCRIPTION:Int = 111
    let TAG_CARD_NUMBER:Int = 122
    let TAG_CARD_EXPIRY:Int = 133
    let TAG_CARD_CVV:Int = 144
    
    var mySelectedIndexPath:Int?
    
    override func viewWillAppear(_ animated: Bool) {
        
        callAccountStatusApi()
        viewWalletAmount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        setUpLeftBarBackButton()
        NAVIGAION.setNavigationTitle(aStrTitle: Booking_service.BOOKING_SERVICE.titlecontent(), aViewController: self)
        myLblLocName.text = Booking_service.TXT_SELECT_LOCATION.titlecontent()
        myLblNoTimeContent.text = Booking_service.NO_TIME_SLOT_AVAILABLE.titlecontent()
        if gBoolIsFromReschedule {
            mySegmentControl.append(title: Booking_service.TIME_DATE.titlecontent())
            myBtnSingle.setTitle(BookingDetailService.BTN_RESCHEDULE.titlecontent(), for: .normal)
            
        }
        else {
            mySegmentControl.append(title: Booking_service.TIME_DATE.titlecontent())
            mySegmentControl.append(title: Booking_service.LOCATION.titlecontent())
            mySegmentControl.append(title: Booking_service.DESCRIPTION.titlecontent())
            myBtnSingle.setTitle(ProviderAndUserScreenTitle.NEXT_TITLE.titlecontent(), for: .normal)
        }
//        mySegmentControl.append(title: Booking_service.TIME_DATE.titlecontent())
//        mySegmentControl.append(title: Booking_service.LOCATION.titlecontent())
//        mySegmentControl.append(title: Booking_service.DESCRIPTION.titlecontent())
        mySegmentControl.font =  UIFont.systemFont(ofSize: 14)
        mySegmentControl.indicatorColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        mySegmentControl.selectedTextColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellTableHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableHeaderIdentifier)
        myTblView.register(UINib.init(nibName: PaymentMethodIdentifier, bundle: nil), forCellReuseIdentifier: PaymentMethodIdentifier)
        myTblView.register(UINib.init(nibName: cellTableDescriptionIdentifier, bundle: nil), forCellReuseIdentifier: cellTableDescriptionIdentifier)
        myTblView.register(UINib.init(nibName: cellTablePaymentIdentifier, bundle: nil), forCellReuseIdentifier: cellTablePaymentIdentifier)
        myTblView.register(UINib.init(nibName: walletTopupCurrentBalanceCellIdentifier, bundle: nil), forCellReuseIdentifier: walletTopupCurrentBalanceCellIdentifier)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.register(UINib(nibName: cellCollectionTimeandDateIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCollectionTimeandDateIdentifier)
        
        //Bottom button
        
//        myContinerViewSingleButton.isHidden = true
          disableNextBtn(isDisabled: true)
        myViewDualButton.isHidden = true
        
//        myBtnSingle.setTitle(ProviderAndUserScreenTitle.NEXT_TITLE.titlecontent(), for: .normal)
        myBtnNext.setTitle(ProviderAndUserScreenTitle.NEXT_TITLE.titlecontent(), for: .normal)
        myButtonPrevious.setTitle(ProviderAndUserScreenTitle.PREVIOUS_TITLE.titlecontent(), for: .normal)
        mySegmentControl.isUserInteractionEnabled = false
        
        myViewPrevious.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myViewNext.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myContinerViewSingleButton.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        HELPER.setRoundCornerView(aView: myViewNext, borderRadius: 15.0)
        HELPER.setRoundCornerView(aView: myViewPrevious, borderRadius: 15.0)
        HELPER.setRoundCornerView(aView: myContinerViewSingleButton, borderRadius: 15.0)
        
        //Calender
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.select(Date())
        
        //        if UIDevice.current.model.hasPrefix("iPad") {
        self.calendarHeightConstraint.constant = 400//self.view.frame.height
        //        }
        self.view.addGestureRecognizer(self.scopeGesture)
        self.myCollectionView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        calendarView.setScope(.week, animated: true)
        calendarView.accessibilityIdentifier = "calendar"
    }
    
    func setUpModel() {
        
        let latitude = (SESSION.getUserLatLong().0 as NSString).doubleValue
        let longitude = (SESSION.getUserLatLong().1 as NSString).doubleValue
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height - 220), camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        mapView.delegate = self
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.myViewMap.addSubview(mapView)
        
        let circleView = UIImageView()
        circleView.image = UIImage(named: "icon_new_location_pin")
        self.mapView.addSubview(circleView)
        view.bringSubviewToFront(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        
        view.updateConstraints()
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
            //            circleView.layer.cornerRadius = 20/2
            circleView.clipsToBounds = true
        })
        
        myViewMap.isHidden = true
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        myStrSelectedDate = result
       
        getBookingTimeFromApi()
    }
    
    func loadModel() {
     
        //        STPPaymentConfiguration.shared().publishableKey = "pk_test_5J1tjkjdwBGS9TdcYm2a5dk2"
    }
    
    // MARK: - Table View delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if mySegmentControl.selectedIndex == 2 {
            
            return 3
        }
        else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if mySegmentControl.selectedIndex == 2 {
            
            return 1
        }
        else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if mySegmentControl.selectedIndex == 2 {
            
            var aCell:HomeNewHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableHeaderIdentifier) as? HomeNewHeaderTableViewCell
              aCell?.gImgViewViewAll.image = UIImage(named: "icon_home_view_all")
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                aCell?.gLblHeader.textAlignment = .right
            }
            else {
                aCell?.gLblHeader.textAlignment = .left
            }
            aCell?.gLblViewAll.text = ""
            aCell?.gBtnViewAll.tag = section
            aCell?.gLblViewAll.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell?.gImgViewViewAll.isHidden = true
            aCell?.backgroundColor = UIColor.clear
            
            if  (aCell == nil) {
                
                let nib:NSArray=Bundle.main.loadNibNamed(cellTableHeaderIdentifier, owner: self, options: nil)! as NSArray
                aCell = nib.object(at: 0) as? HomeNewHeaderTableViewCell
            }
                
            else {
                
                if section == 0 {
                    
                    aCell?.gLblHeader.text = Booking_service.MESSAGE_TO_PROVIDER.titlecontent()
                }
                else {
                    
                    aCell?.gLblHeader.text = Booking_service.PAYMENT_DETAILS.titlecontent()
                }
                
                aCell?.gViewDesign.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
                HELPER.setRoundCornerView(aView: aCell!.gViewDesign, borderRadius: 2.5)
            }
            
            return aCell
        }
        else {
            
            return nil
        }
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        return UITableViewAutomaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if mySegmentControl.selectedIndex == 2 {
            
            if indexPath.section == 0 {
                
                return 100
            }
            else if indexPath.section == 1 {
                
                return 80
            }
            else {
                
                return 60
            }
        }
        else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if mySegmentControl.selectedIndex == 2 {
            
            if indexPath.section == 0 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableDescriptionIdentifier, for: indexPath) as! NewBookNowDescriptionTableViewCell
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTxtViewDescription.textAlignment = .right
                }
                else {
                     aCell.gTxtViewDescription.textAlignment = .left
                }
                aCell.gTxtViewDescription.delegate = self
               
                aCell.gTxtViewDescription.tag = TAG_DESCRIPTION
                
                return aCell
            }
            else if indexPath.section == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: walletTopupCurrentBalanceCellIdentifier, for: indexPath) as! WalletTopupCurrentBalanceTableViewCell
                cell.gViewWalletView.layer.cornerRadius = cell.gViewWalletView.frame.height / 2
                let aStrCurrency = (myDictWalletInfo["currency"] as? String)!
                 cell.gLblWalletBalenceHeading.text = WalletContent.CURRENT_BAL.titlecontent()
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                                  cell.gLblCurrentBalance.textAlignment = .left
                              }
                              else {
                                   cell.gLblCurrentBalance.textAlignment = .right
                              }
                cell.gLblCurrentBalance.text = aStrCurrency.html2String + ((myDictWalletInfo["wallet_amt"] as? String)!)
                return cell
               
            }
            else {
                let aCell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodIdentifier, for: indexPath) as! PaymentMethodTableViewCell
                if myStrPaymentmethod == "2" {
                    aCell.gImgWalletRadio.image = UIImage(named: "icon_radio_tick_gray")
                    aCell.gImgCodRadio.image = UIImage(named: "icon_radio_untick_blue")
                }
                else if myStrPaymentmethod == "1" {
                    aCell.gImgCodRadio.image = UIImage(named: "icon_radio_tick_gray")
                    aCell.gImgWalletRadio.image = UIImage(named: "icon_radio_untick_blue")
                }
                else {
                    aCell.gImgWalletRadio.image = UIImage(named: "icon_radio_untick_blue")
                    aCell.gImgCodRadio.image = UIImage(named: "icon_radio_untick_blue")
                }
                
                aCell.gLblCod.text = Booking_service.COD.titlecontent()
                aCell.gLblWallet.text = Booking_service.WALLET.titlecontent()
                aCell.gBtnCod.addTarget(self, action: #selector(BtnCodTapped(_:)), for: .touchUpInside)
                aCell.gBtnWallet.addTarget(self, action: #selector(BtnWalletTapped(_:)), for: .touchUpInside)
                
                return aCell
            }
        }
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableHeaderIdentifier, for: indexPath) as! HomeNewHeaderTableViewCell
            
            return aCell
        }
    }
    
    // MARK: - Collection View Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myAryTimeInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCollectionTimeandDateIdentifier, for: indexPath) as! NewBookNowTimeDateListCollectionViewCell
        
        //        HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 15.0)
        //RTL
        aCell.gLblFromContent.text = Booking_service.FROM.titlecontent()
         aCell.gLblToContent.text = Booking_service.TO.titlecontent()
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell.gLblTimingContent.textAlignment = .right
        }
        else {
             aCell.gLblTimingContent.textAlignment = .left
        }
        aCell.gLblTimingContent.text = Booking_service.TIMINGS.titlecontent()
        aCell.gLblFromContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        aCell.gLblToContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        HELPER.setRoundCornerView(aView: aCell.gViewTimingColor, borderRadius: 2.5)
        
        if (indexPath.row % 2 == 0) {
            
            aCell.gViewTimingColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        }
        else {
            
            aCell.gViewTimingColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
        }
        
        if myAryTimeInfo.count != 0 {
            if WEB_TIME_FORMAT == "hh:mm a" {
            aCell.gLblFromTime.text = HELPER.returnStringFromNull(myAryTimeInfo[indexPath.row]["start_time"] as AnyObject) as? String//myAryTimeInfo[indexPath.row]["start_time"] as? String
            aCell.gLblToTime.text = HELPER.returnStringFromNull(myAryTimeInfo[indexPath.row]["end_time"] as AnyObject) as? String  //myAryTimeInfo[indexPath.row]["end_time"] as? String
            } else {
                let dateAsString = myAryTimeInfo[indexPath.row]["start_time"] as? String
                let date2AsString = myAryTimeInfo[indexPath.row]["start_time"] as? String
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
        }
        
      
        
        if mySelectedIndexPath == indexPath.row {
            disableNextBtn(isDisabled: false)
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 1.0, borderColor: HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), cornerRadius: 15.0)
        }
        else {
            
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 1.0, borderColor: .clear, cornerRadius: 15.0)
        }
        
        return aCell
    }
    func disableNextBtn(isDisabled : Bool)  {
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            if isDisabled {
                
                self.myContinerViewSingleButton.isUserInteractionEnabled = false
                self.myContinerViewSingleButton.alpha = 0.3
            }
                
            else {
                
                self.myContinerViewSingleButton.isUserInteractionEnabled = true
                self.myContinerViewSingleButton.alpha = 1
            }
            
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var aDictInfo = myAryTimeInfo[indexPath.row]
        let aStr = aDictInfo["is_selected"] as! String
        aDictInfo["is_selected"] = aStr == "0" ? "1" : "0"
        
        mySelectedIndexPath = indexPath.row
        
        myStrFromTime = aDictInfo["start_time"] as! String
        myStrToTime = aDictInfo["end_time"] as! String
        //        myAryInfo[sender.tag] = aDictInfo
        
        myAryTimeInfo[indexPath.row] = aDictInfo
        self.myCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2, height: 120)
    }
    
    // MARK: - Textfield Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_CARD_NUMBER {
            
            myStrCardNo = txtAfterUpdate
        }
        else if textField.tag == TAG_CARD_EXPIRY {
            
            myStrCardExp = txtAfterUpdate
        }
        else if textField.tag == TAG_CARD_CVV {
            
            myStrCardCvv = txtAfterUpdate
        }
        
        return true;
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        
        textfield.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: - TextView Delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_DESCRIPTION {
            
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_DESCRIPTION {
            
            if textView.text == "" {
                
                textView.text = Booking_service.LEAVE_DESCRIPTION.titlecontent()
                textView.textColor = UIColor.lightGray
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let characterLimit = 100
        let textViewText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textViewText.replacingCharacters(in: range, with: text)
        let numberOfChars = txtAfterUpdate.count
        if textView.tag == TAG_DESCRIPTION {
            myStrDescription = txtAfterUpdate
        }
         return numberOfChars <= characterLimit
    }
    
    // MARK:- Google map functions
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        SESSION.setUserUpdatedLatLonginGoogleSearch(lat: String(latitude), long:String( longitude))
        
        let location = CLLocation(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude)
        
        fetchCountryAndCity(location: location) { country, city in
            print("country:", country)
            print("city:", city)
            
            self.myStrLat = SESSION.getUserUpdatedLatLonginGoogleSearch().0
            self.myStrLong = SESSION.getUserUpdatedLatLonginGoogleSearch().1
            self.myStrLocName = city + "," + country
            self.myLblLocName.text = currentlocString
        }
    }
    
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = centerMapCoordinate
        marker.map = self.mapView
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.myCollectionView.contentOffset.y <= -self.myCollectionView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch calendarView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    //    func maximumDate(for calendar: FSCalendar) -> Date {
    //        return Date()
    //    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //        if calendar.scope == .week{
        //            self.calendarHeightConstraint.constant = 160
        //        }else{
        self.calendarHeightConstraint.constant = bounds.height
        //        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        myStrSelectedDate = selectedDates[0]
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        getBookingTimeFromApi()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        let curDate = Date().addingTimeInterval(-24*60*60)
        
        if date < curDate {
            return false
        } else {
            return true
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
   
  

    
    // MARK:- Button Action
    @IBAction func BtnCodTapped(_ sender: Any) {
        myStrPaymentmethod = "1"
        mySegmentControl.select(index: 2, animated: true)
    }
    
    @IBAction func BtnWalletTapped(_ sender: Any) {
        myStrPaymentmethod = "2"
        mySegmentControl.select(index: 2, animated: true)
    }
    @IBAction func myBtnSingleTapped(_ sender: Any) {
        if gBoolIsFromReschedule {
            sendRescheduleTimeToApi()
        }
        else {
            myContinerViewSingleButton.isHidden = true
            myViewDualButton.isHidden = false
            
            mySegmentControl.select(index: 1, animated: true)
        }
      
    }
    func sendRescheduleTimeToApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        
        var aDictParams = [String:String]()
        aDictParams["booking_id"] = self.gStrBookingID
        aDictParams["service_id"] = self.gStrServiceID
        aDictParams["booking_date"] = self.myStrSelectedDate
        aDictParams["from_time"] = self.myStrFromTime
        aDictParams["to_time"] = self.myStrToTime
        aDictParams["notes"] = self.gStrNotes
        
        
        print(aDictParams)
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_RESCHEDULE_TIME, dictParameters: aDictParams , sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else {
                    
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
        
    }
    @IBAction func myBtnPreviousTapped(_ sender: Any) {
        
        if mySegmentControl.selectedIndex == 1 {
            
            myContinerViewSingleButton.isHidden = false
            myViewDualButton.isHidden = true
            myBtnSingle.setTitle(ProviderAndUserScreenTitle.NEXT_TITLE.titlecontent(), for: .normal)
            mySegmentControl.select(index: 0, animated: true)
        }
        else {
            
            myBtnNext.setTitle(ProviderAndUserScreenTitle.NEXT_TITLE.titlecontent(), for: .normal)
            mySegmentControl.select(index: 1, animated: true)
        }
    }
    
    @IBAction func myBtnNextTapped(_ sender: Any) {
        let myIntServiceAmount = (gStrServiceAmount as NSString).integerValue
        let myIntWalletAmount = (myDictWalletInfo["wallet_amt"] as! NSString).integerValue
        if mySegmentControl.selectedIndex == 1 {
            
            myBtnNext.setTitle(Booking_service.BOOK_NOW.titlecontent(), for: .normal)
            mySegmentControl.select(index: 2, animated: true)
        }
        else {
            
            if myStrAccountCheck.count != 0 {
                                
                if myStrFromTime.count == 0 {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: Booking_service.SELECT_TIME_SLOT.titlecontent())
                    return
                }
                else if myStrLocName.count == 0 {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: Booking_service.SELECT_LOCATION.titlecontent())
                    return
                }
                else if myStrDescription.count == 0 {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: Booking_service.ENTER_DESC_FOR_BOOKING.titlecontent())
                    return
                }
                else if self.myStrPaymentmethod == "1" {
                    sendBookingToApi()
                }
                else if self.myStrPaymentmethod == "2" {
                    if myIntServiceAmount > myIntWalletAmount {
                        
                        print(myIntServiceAmount)
                        print(myIntWalletAmount)
                        HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: Booking_service.INSUFFICIENT_BALANCE.titlecontent()) { (action) in
                            let aViewController = GSWaletViewController()
                            aViewController.gBoolIsFromBooking = true
                            self.navigationController?.pushViewController(aViewController, animated: true)
                        }
                        
                    }
                    else {
                        sendBookingToApi()
                    }
                    
                }

            }
        }
    }
    
    @IBAction func mySegmentTapped(_ sender: Any) {
        
        switch mySegmentControl.selectedIndex
        {
        //Time and date
        case 0:
            
            self.myViewMap.isHidden = true
            self.myTblView.isHidden = true
            self.myViewTimeandDate.isHidden = false
            self.myTblView.reloadData()
        //Location
        case 1:
            
            self.myViewMap.isHidden = false
            self.myViewTimeandDate.isHidden = true
            self.myTblView.isHidden = false
            self.myTblView.reloadData()
        //Description
        case 2:
            
            self.myViewMap.isHidden = true
            //            self.mySearchLocation.isHidden = true
            self.myViewTimeandDate.isHidden = true
            self.myTblView.isHidden = false
            self.myTblView.reloadData()
        default:
            break;
        }
    }
    
    // MARK:- Api Call
    func sendBookingToApi() {
        
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        
        var aDictParams = [String:String]()
        aDictParams["from_time"] = self.myStrFromTime
        aDictParams["to_time"] = self.myStrToTime
        aDictParams["service_id"] = self.gStrServiceID
        aDictParams["service_date"] = self.myStrSelectedDate
        aDictParams["latitude"] = self.myStrLat
        aDictParams["longitude"] = self.myStrLong
        aDictParams["location"] = self.myStrLocName
        aDictParams["notes"] = self.myStrDescription
        aDictParams["amount"] = self.gStrServiceAmount
        aDictParams["cod"] = self.myStrPaymentmethod
        print(aDictParams)
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BOOKING_SERVICE, dictParameters: aDictParams , sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        APPDELEGATE.loadTabbar()
//                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else {
                    
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
        
    }


func viewWalletAmount() {
    if !HELPER.isConnectedToNetwork() {
               
               HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
               return
           }
    HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
    
    let aDictParams = [String:String]()
    HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_WALLET_AMOUNT,dictParameters:aDictParams, sucessBlock: { response in
        
        HELPER.hideLoadingAnimation()
        
        if response.count != 0 {
            
            var aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                var aDictResponseData = [String:Any]()
                aDictResponseData = response["data"] as! [String : Any]
                self.myDictWalletInfo = aDictResponseData["wallet_info"] as! [String : Any]
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

func getBookingTimeFromApi() {
    if !HELPER.isConnectedToNetwork() {
               
               HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
               return
           }
    HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
    
    var aDictParams = [String:String]()
    aDictParams["date"] = myStrSelectedDate
    aDictParams["service_id"] = gStrServiceID
    
    HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BOOKING_TIME,dictParameters:aDictParams, sucessBlock: { response in
        
        HELPER.hideLoadingAnimation()
        
        if response.count != 0 {
            
            var aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                var aDictResponseData = [String:Any]()
                aDictResponseData = response["data"] as! [String:Any]
                
                if aDictResponseData.count != 0 {
                    
                    self.myAryTimeInfo = aDictResponseData["service_availability"] as! [[String : Any]]
                    //                    self.myCollectionView.isHidden = false
                    self.myLblNoTimeContent.isHidden = true
                    self.myCollectionView.reloadData()
                    HELPER.hideLoadingAnimation()
                }
                else {
                    self.myAryTimeInfo.removeAll()
                    //                self.myCollectionView.isHidden = true
                    self.myLblNoTimeContent.isHidden = false
                    self.myCollectionView.reloadData()
                    HELPER.hideLoadingAnimation()
                }
                
//                HELPER.hideLoadingAnimation()
            }
            else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                
            }
            else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA_500) {
                
                self.myAryTimeInfo.removeAll()
                //                self.myCollectionView.isHidden = true
                self.myLblNoTimeContent.isHidden = false
                self.myCollectionView.reloadData()
                HELPER.hideLoadingAnimation()
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

//Booking api
func sendBookingFromApi() {
    if !HELPER.isConnectedToNetwork() {
               
               HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
               return
           }
    HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
    
    var aDictParams = [String:String]()
    aDictParams["from_time"] = myStrFromTime
    aDictParams["to_time"] = myStrToTime
    aDictParams["service_id"] = gStrServiceID
    aDictParams["service_date"] = myStrSelectedDate
    aDictParams["latitude"] = myStrLat
    aDictParams["longitude"] = myStrLong
    aDictParams["location"] = myStrLocName
    aDictParams["notes"] = myStrDescription
    aDictParams["amount"] = gStrServiceAmount
    aDictParams["tokenid"] = gStrServiceID
    
    HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BOOKING_TIME,dictParameters:aDictParams, sucessBlock: { response in
        
        HELPER.hideLoadingAnimation()
        
        if response.count != 0 {
            
            var aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                var aDictResponseData = [String:Any]()
                aDictResponseData = response["data"] as! [String:Any]
                
                if aDictResponseData.count != 0 {
                    
                    self.myAryTimeInfo = aDictResponseData["service_availability"] as! [[String : Any]]
                    //                    self.myCollectionView.isHidden = false
                    self.myLblNoTimeContent.isHidden = true
                    self.myCollectionView.reloadData()
                    HELPER.hideLoadingAnimation()
                }
                
                HELPER.hideLoadingAnimation()
            }
            else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                
            }
            else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA_500) {
                
                self.myAryTimeInfo.removeAll()
                //                self.myCollectionView.isHidden = true
                self.myLblNoTimeContent.isHidden = false
                self.myCollectionView.reloadData()
                HELPER.hideLoadingAnimation()
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
                self.myStrAccountCheck = aDictResponse["account_details"]!
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
//    leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
    leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    
    leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
    
    let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
    self.navigationItem.leftBarButtonItem = leftBarBtnItem
}

@objc func backBtnTapped() {
    
    self.navigationController?.popViewController(animated: true)
}
}
