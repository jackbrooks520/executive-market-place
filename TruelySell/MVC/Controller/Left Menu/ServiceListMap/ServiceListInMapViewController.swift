//
//  ServiceListInMapViewController.swift
//  TruelySell
//
//  Created by DreamGuys Tech on 21/10/21.
//  Copyright © 2021 dreams. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import MapViewPlus

class ImageAnnotation: CalloutViewModel  {
    var title: String
    var subtitle: String?
    var image: String?
    var colour: UIColor?
    var jobId: String?
    var price: String?
    
    init(title: String, image: String ,subtitle: String, jobId : String, price : String ) {
        self.title = title
        self.image = image
        self.subtitle = subtitle
        self.jobId = jobId
        self.price = price
        self.colour = UIColor.white
    }
}
class ImageAnnotationView: MKAnnotationView {
   
    private var imageView: UIImageView!
    var imageViewInside: UIImageView!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.imageView.contentMode = .scaleAspectFit
        
        self.imageViewInside = UIImageView(frame: CGRect(x: 15, y: 7, width: 20, height: 20))
        self.imageView.contentMode = .scaleAspectFit

        self.addSubview(self.imageView)
        self.addSubview(self.imageViewInside)

        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
        self.imageViewInside.layer.cornerRadius = 10
        self.imageViewInside.layer.masksToBounds = true
    }

    override var image: UIImage? {
        get {
            return self.imageView.image
        }

        set {
            self.imageView.image = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ServiceListInMapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var myMapView: MapViewPlus!
    //    @IBOutlet weak var myMapView: MKMapView!
    weak var currentCalloutView: UIView?
    let locationManager = CLLocationManager()
    var myBoolZoom: Bool = true
    var myAryJobList = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMapView.delegate = self
        myMapView.anchorViewCustomizerDelegate = self
        setupUI()
        setupModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        NAVIGAION.setNavigationTitle(aStrTitle: HomeScreenContents.SERVICE.titlecontent(), aViewController: self)
     
        self.setUpLeftBarBackButton()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        myMapView.delegate = self
        myMapView.mapType = .standard
        myMapView.isZoomEnabled = true
        myMapView.isScrollEnabled = true
        myMapView.showsUserLocation = true
        
        if let coor = myMapView.userLocation.location?.coordinate{
            myMapView.setCenter(coor, animated: true)
        }
    }
    
    func setupModel() {


    }
    
    func loadModel() {
        self.updateMapView()
//        callgetJobList()
    }
    
    // MARK: - Left Bar Button Methods
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            leftBtn.setImage(UIImage(named: ICON_BACK)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        else {
            leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        }
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func backBtnTapped() {
       // self.navigationController?.popViewController(animated: true)        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

    //MARK: Map Functions
    func updateMapView() {

        var locationInfo = [[String: Any]]()

        for service in self.myAryJobList {
            
            var dict = [String: Any]()

            let latitude = "\(service["service_latitude"] ?? "")"
            let longitude = "\(service["service_longitude"] ?? "")"
            
            if latitude != "" && longitude != "" {
                let coordinate = CLLocation(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
                                
                dict["cllocation"] = coordinate
                dict["imgUrl"] = service["service_image"]  as! String
                dict["serviceId"] = service["service_id"]  as! String
                dict["serviceTitle"] = service["service_title"]  as! String
                dict["categoryName"] = service["category_name"]  as! String
                let aStrCurrency = service["currency"]  as! String
                let aStrAmount = service["service_amount"]  as! String
                dict["price"] = aStrCurrency + "\(aStrAmount)"
                locationInfo.append(dict)
            }
        }
      
        if locationInfo.count != 0 {
            self.addAnnotations(locattionInfo: locationInfo)
        }
    }
    
    func addAnnotations(locattionInfo: [[String: Any]]) {
        var annotations: [AnnotationPlus] = []
        for loc in locattionInfo {

            let coord = loc["cllocation"] as! CLLocation
            let imgUrl = loc["imgUrl"] as! String
            let id = loc["serviceId"] as! String
           let strSubTitle = loc["categoryName"] as! String
            let strTitle = loc["serviceTitle"] as! String
            let strPrice = loc["price"] as! String
            annotations.append(AnnotationPlus.init(viewModel: ImageAnnotation(title: strTitle, image: imgUrl, subtitle: strSubTitle, jobId: id, price: strPrice), coordinate: CLLocationCoordinate2DMake(coord.coordinate.latitude, coord.coordinate.longitude)))
        }
        myMapView.setup(withAnnotations: annotations)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
          //  let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            let region = MKCoordinateRegion( center: center, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
           if myBoolZoom {
               self.myMapView.setRegion(region, animated: true)
               myBoolZoom = false
            }
           
        }
    }


    //MARK: API Call
    func callgetJobList() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = ["latitude":SESSION.getUserLatLong().0, "longitude":SESSION.getUserLatLong().1,"type":"Popular"]
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_VIEW_ALL,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    
                    aDictResponseData = response["data"] as! [String : Any]
                    
                    self.myAryJobList = aDictResponseData["service_list"] as! [[String : Any]]
                    self.updateMapView()
                    
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

}
extension ServiceListInMapViewController: MapViewPlusDelegate {
    func mapView(_ mapView: MapViewPlus, imageFor annotation: AnnotationPlus) -> UIImage {
        return UIImage(named: "icon_map_pin")!
    }
    
    func mapView(_ mapView: MapViewPlus, calloutViewFor annotationView: AnnotationViewPlus) -> CalloutViewPlus{
        let calloutView = Bundle.main.loadNibNamed("BasicCalloutView", owner: nil, options: nil)!.first as! BasicCalloutView
        calloutView.delegate = self
        currentCalloutView = calloutView
        return calloutView
    }
    
    // Optional
    func mapView(_ mapView: MapViewPlus, didAddAnnotations annotations: [AnnotationPlus]) {
        mapView.showAnnotations(annotations, animated: true)
    }
}

extension ServiceListInMapViewController: AnchorViewCustomizerDelegate {
    func mapView(_ mapView: MapViewPlus, fillColorForAnchorOf calloutView: CalloutViewPlus) -> UIColor {
        return currentCalloutView?.backgroundColor ?? mapView.defaultFillColorForAnchors
    }
}

extension ServiceListInMapViewController: BasicCalloutViewModelDelegate {
    func detailButtonTapped(withTitle title: String , withId id: String) {
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_DETAIL_VC) as! HomeNewDetailViewController
        aViewController.gStrServiceId = id
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
}
