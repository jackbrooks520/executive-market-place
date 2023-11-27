//
//  GoogleMapsViewController.swift
//
//  Created by Leo Chelliah on 02/05/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

struct placeDetails {
    let Name:NSString
    var Address:NSString
    var placeID:NSString
}
var currentlocString = ""
class GoogleMapsViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    // MARK:- Instance variables
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    
    var searchActive : Bool = false
    var priorSearchText:String!
    var fetcher: GMSAutocompleteFetcher?
    var placeInfo: [placeDetails] = []
    var locName = ""
    var locAddress = ""
    var isFromSettings = false
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var placeSearchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    typealias CompletionBlock = (String?,String?) -> Void
    var completion: CompletionBlock = { reason,reason1  in print(reason ?? false) }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 56, width: self.view.frame.size.width, height: self.view.frame.size.height - 176), camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 50)

        self.view .addSubview(mapView)
        
        self.initLocationManager()

         setUpUI()
        // Do any additional setup after loading the view.
    }

    
    func setUpUI()  {
        
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: Booking_service.LOCATION.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        if(isLocationEnabled()) {
            // Set bounds to inner-west Sydney Australia.
            let neBoundsCorner = CLLocationCoordinate2D(latitude: currentLocation.latitude,
                                                        longitude: currentLocation.longitude)
            let swBoundsCorner = CLLocationCoordinate2D(latitude: currentLocation.latitude,
                                                        longitude: currentLocation.longitude)
            
            
            let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                             coordinate: swBoundsCorner)
            // Create the fetcher.
            fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
            fetcher?.delegate = self
            
        }
        else {
            // Set up the autocomplete filter.
            // Create the fetcher.
            fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
            fetcher?.delegate = self
            
        }
        
        self.locationTableView!.register(UINib(nibName: "GoogleAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "GoogleAddressTableViewCell")
        self.locationTableView.isHidden = true
        self.locationTableView.tableFooterView = UIView()
        self.doneBtn.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
    }
    
    //MARK:-  Tableview delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.placeInfo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GoogleAddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GoogleAddressTableViewCell", for: indexPath) as! GoogleAddressTableViewCell
     
        cell.nameLbl.text = self.placeInfo[indexPath.row].Name as String
        cell.addresslbl.text = self.placeInfo[indexPath.row].Address as String
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        let  detail = self.placeInfo[indexPath.row]
        
        getAddressDetailFromPlaceId(placeId: detail.placeID as String, completion: { (lat, long) in
            currentLocation = CLLocationCoordinate2DMake(lat, long)
            self.locName = detail.Name as String
            self.locAddress = ""
            if detail.Name != detail.Address {
            self.locAddress = detail.Address as String
            }
            self .showSelectedLocation(title: detail.Name as String)
            
            if self.isFromSettings == true {
                SESSION.setUserLatLong(lat: String(lat), long:String(long))
                SESSION.setUserLocName(aStrUserLocName: detail.Name as String)
            }

            SESSION.setUserLocName(aStrUserLocName: detail.Name as String)
            SESSION.setUserUpdatedLatLonginGoogleSearch(lat: String(lat), long:String(long))

            
        }) { (error) in
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK:- Searchbar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        mapView.isHidden = true
        self.locationTableView.isHidden = false
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
        self.fectchAddress(searchText: searchText)
        
    }
    
    func fectchAddress(searchText:String) {
        
        fetcher?.sourceTextHasChanged(searchText)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.resignFirstResponder()
        return true
    }
    
    // MARK:- Button Action
    
    @IBAction func didTapOnDoneBtn(_ sender: Any) {
        
        self.completion(locName, locAddress)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: CLLocaitonManager Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!.coordinate
        
        print("locations = \(locations)")
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 15);
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker(position: center)
        
        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        marker.map = mapView
        
        let location = CLLocation(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        if isFromSettings == true {
            SESSION.setUserLatLong(lat: String(userLocation!.coordinate.latitude), long:String(userLocation!.coordinate.longitude))
            
        }
        SESSION.setUserUpdatedLatLonginGoogleSearch(lat: String(userLocation!.coordinate.latitude), long:String( userLocation!.coordinate.longitude))
        
        fetchCountryAndCity(location: location) { country, city in
            print("country:", country)
            print("city:", city)
            marker.title = city
            self.locName = city
            self.locAddress = country
            currentlocString = city + country
            
        }
        
        locationManager.stopUpdatingLocation()
        
        setUpUI()
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
    func showSelectedLocation(title:String)  {
        
        let center = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: 15);
        
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker(position: center)
        marker.map = mapView
        
        marker.title = title
        mapView.isHidden = false
        locationTableView.isHidden = true
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("HomeView location not fetching\(error.localizedDescription)")
        setUpUI()
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
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }

    func locationnotAllowedAlert()  {
        
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_LOCATION_POPUP_VC) as! LocationPopViewController
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
}

extension GoogleMapsViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        let resultsStr = NSMutableString()
        print(predictions)
        self.placeInfo.removeAll()
        for prediction in predictions {
            let addText = prediction.attributedFullText.string
            var separateTxt = addText.components(separatedBy: ",")
            let omitTxt =   "\(separateTxt[0]),"
            
            let fullAddress = addText.replacingOccurrences(of: omitTxt, with: "")
            
            let fullAddressTxt = fullAddress
            //  fullAddressTxt.remove(at: fullAddressTxt.startIndex)  //commented for first character not shown issue
            let placeId = prediction.placeID
        
            
            
            let placeInfo = placeDetails(Name: separateTxt[0] as NSString, Address: fullAddressTxt as NSString, placeID: placeId as NSString)
            self.placeInfo.append(placeInfo)
        }
        print(resultsStr as String)
        searchActive = false
        locationTableView .reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
            searchActive = false
    }
    
    func getAddressDetailFromPlaceId(placeId:String,completion:@escaping (_ lat:Double,_ long:Double) -> Void , failure:@escaping (Error) -> Void)  {
        
        
        GMSPlacesClient.shared().lookUpPlaceID(placeId) { (place, error) in
            if let error = error {
                
                print("lookup place id query error: \(error.localizedDescription)")
               
                
                let alert = UIAlertController(title: "Google Places Api error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction)in
                    // controller.navigationController?.popToRootViewController(animated: true)
                }));
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if let place = place {
                print("Place name \(place.name)")
                print("Place address:------>\(String(describing: place.formattedAddress))")
                print("Place placeID \(place.placeID)")
                print("Place attributions \(String(describing: place.attributions))")
                print("Place types \(place.types)")
                print("Place no \(String(describing: place.phoneNumber))")
                print("Place address \(String(describing: place.addressComponents))")
                
                print(place)
          
                completion(place.coordinate.latitude,  place.coordinate.longitude)
                
                
            } else {
                print("No place details for \(placeId)")
                failure (NSError(domain: "noinfo", code: 123, userInfo: nil))
            }
        }
    }
}
