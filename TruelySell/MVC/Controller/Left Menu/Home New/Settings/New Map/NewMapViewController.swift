 
import UIKit
import GoogleMaps
import GooglePlaces
import MapKit

class NewMapViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var myBtnDone: UIButton!
    @IBOutlet weak var myViewSubmitButton: UIView!
    @IBOutlet weak var myLblLocationName: UILabel!
    @IBOutlet weak var myContainerView: UIView!
    
    lazy var mapView = GMSMapView()
    
    var locationManager = CLLocationManager()
    var centerMapCoordinate:CLLocationCoordinate2D!
    var currentLocation: CLLocation!
    var timer: Timer?
    var currZoom = Float()
    var myStrLat = String()
    var myStrLong = String()
    var myStrLocName = String()
    var gStrLat = String()
    var gStrLong = String()
    var myCurrentLat = String()
    var myCurrentLong = String()
    
    var isFromAddService:Bool = false
    
    typealias CompletionBlockNewMap = (String?,String?,String?) -> Void
    var completionNewMap: CompletionBlockNewMap = { reasonNewMap,reasonNewMap1,reasonNewMap2  in print(reasonNewMap ?? false) }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
//        setUpModel()
        loadModel()
        self.initLocationManager()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: SettingsLangContents.SET_LOCATION_TITLE.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
        myViewSubmitButton.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        HELPER.setRoundCornerView(aView: myViewSubmitButton, borderRadius: 15.0)
        myBtnDone.setTitle(CommonTitle.DONE_BTN.titlecontent(), for: .normal)

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        if SESSION.getLocationZoom() == 0.0 {
            SESSION.setLocationZoom(zoom: 15.0)
        }
    }
    
    func setUpModel() {
        
        var lat = String()
        var long = String()
        
        if isFromAddService == true {
            
            if gStrLat.count != 0 {
                
                lat = gStrLat
                long = gStrLong
            }
            else {
                
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
                locationManager.requestWhenInUseAuthorization()
                
                if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                    
                    guard let currentLocation = locationManager.location else {
                        return
                    }
                    
                    print(currentLocation.coordinate.latitude)
                    print(currentLocation.coordinate.longitude)
                    
                    lat = myCurrentLat
                    long = myCurrentLong
                }
            }
        }
        else {
            
            lat = SESSION.getUserLatLong().0
            long = SESSION.getUserLatLong().1
        }
        
        let latitude = (lat as NSString).doubleValue
        let longitude = (long as NSString).doubleValue
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        fetchCountryAndCityNewMap(location: location) { country, city, locationname in
            print("country:", country)
            print("city:", city)
            
            self.myStrLat = SESSION.getUserUpdatedLatLonginGoogleSearch().0
            self.myStrLong = SESSION.getUserUpdatedLatLonginGoogleSearch().1
            if city != "" {
            self.myStrLocName = city + "," + country
            self.myLblLocationName.text = self.myStrLocName
            }
            else {
                self.myStrLocName = locationname + "," + country
                self.myLblLocationName.text = self.myStrLocName
            }
        }
       
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: SESSION.getLocationZoom())
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height ), camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        mapView.delegate = self
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.myContainerView.addSubview(mapView)
        
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
            circleView.clipsToBounds = true
        })
    }
    
    // MARK: CLLocaitonManager Delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = manager.location!.coordinate
        
        let userLocation = locations.last
        
        if SESSION.getUserLatLong().0.count != 0 && SESSION.getUserLatLong().1.count != 0 {
            
            myCurrentLat = gStrLat
            myCurrentLong = gStrLong
        }
        else {
            
            myCurrentLat = String(userLocation!.coordinate.latitude)
            myCurrentLong = String(userLocation!.coordinate.longitude)
        }
        
        setUpModel()
        locationManager.stopUpdatingLocation()
    }

    func loadModel() {
        
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK:- Google map functions
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
         currZoom = self.mapView.camera.zoom
        print(currZoom)
       
//
//        let latitude = mapView.camera.target.latitude
//        let longitude = mapView.camera.target.longitude
//        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//        SESSION.setUserUpdatedLatLonginGoogleSearch(lat: String(latitude), long:String( longitude))
//
//        let location = CLLocation(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude)
//
//        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
//
//            self?.fetchCountryAndCityNewMap(location: location) { country, city in
//                print("country:", country)
//                print("city:", city)
//
//                self!.myStrLat = SESSION.getUserUpdatedLatLonginGoogleSearch().0
//                self!.myStrLong = SESSION.getUserUpdatedLatLonginGoogleSearch().1
//                self!.myStrLocName = city + "," + country
//                self!.myLblLocationName.text = self?.myStrLocName
//            }
//        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)

        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        self.fetchCountryAndCityNewMap(location: location) { country, city, locationname in
            print("country:", country)
            print("city:", city)
            HELPER.hideLoadingAnimation()

            self.myStrLat = String(location.coordinate.latitude)
            self.myStrLong = String(location.coordinate.longitude)
            if city != "" {
            self.myStrLocName = city + "," + country
            self.myLblLocationName.text = self.myStrLocName
            }
            else {
                self.myStrLocName = locationname + "," + country
                self.myLblLocationName.text = self.myStrLocName
            }
        }
    }
    
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = centerMapCoordinate
        marker.map = self.mapView
    }
    
    func fetchCountryAndCityNewMap(location: CLLocation, completion: @escaping (String, String, String) -> ()) {
        
        print(location)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality, let locationName = placemarks?.first?.name {
                completion(country, city, locationName)
            }
            else {
            let country = placemarks?.first?.country ?? ""
            let city = placemarks?.first?.locality ?? ""
            let locationName = placemarks?.first?.name ?? ""
           
            completion(country, city, locationName)
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            // locationStatus = "Restricted Access to location"
            print("Restricted Access to location")
            self .locationnotAllowedAlert()
            
        case CLAuthorizationStatus.denied:
            // locationStatus = "User denied access to location"
            self .locationnotAllowedAlert()
            print("User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            // locationStatus = "Status not determined"
            print("Status not determined")
        default:
            // locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        //   NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
        }
    }
    
    func isLocationEnabled() -> (Bool){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return true
            default:
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    func locationnotAllowedAlert()  {
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
            self.navigationController?.popViewController(animated: true)
        })
//        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_LOCATION_POPUP_VC) as! LocationPopViewController
//        self.present(aViewController, animated: true, completion: nil)
    }

    // MARK:- Button Action
    @IBAction func btnDoneTapped(_ sender: Any) {
        SESSION.setLocationZoom(zoom: currZoom)
        if isFromAddService == true {
            
            self.completionNewMap(myStrLat, myStrLong, myStrLocName)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            
            SESSION.setUserLatLong(lat: self.myStrLat, long:self.myStrLong)
            SESSION.setUsesetLocationNameUpdate(name: self.myStrLocName)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func applicationDidBecomeActive() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                SESSION.setUserLatLong(lat: "", long: "")
                self.navigationController?.popViewController(animated: true)
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.startUpdatingLocation()
            default: break
              
            }
        } else {
        }
        
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



