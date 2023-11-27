//
//  GSMapDirectionViewController.swift
//  AuctioneerScript
//
//  Created by DreamGuys Tech on 20/10/20.
//  Copyright © 2020 dreams. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Presentr

protocol BuyerLocationReceiver {
    func didReceive(location: CLLocationCoordinate2D, rotation: Double)
}

var buyerLocationReceiver: GSMapDirectionViewController? = nil

class GSMapDirectionViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D? = nil
    var destinationLocation: CLLocationCoordinate2D? = nil
    
    var oldcurrentLocation: CLLocationCoordinate2D? = nil
    var olddestinationLocation: CLLocationCoordinate2D? = nil
    var rotation: Double = 0
    var isFromSeller = false
    var isLocationUpdated = true
    var isMapLoadedFirsttime = true
    var strDeliveryMode = "1"
    var TAG_SWIPE_TO_COMPLETE = 10
    var TAG_SWIPE_TO_CANCEL = 20
    
    var orderId = ""
    var strUserId = String()
    var strUserName = String()
    var strBookingId = String()
    var strDistance = String()
    
    private var myCarMarker = GMSMarker()
    private var destinationMarker = GMSMarker()
    
    private var lastUpdatedTime: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        NAVIGAION.setNavigationTitle(aStrTitle: Booking_service.LOCATION.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
    }
    
    
    func setUpUI() {
        
        var aDictParams = [String:String]()
        aDictParams["device_type"] = "ios"
        aDictParams["device_token"] = SESSION.getDeviceToken()
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_NEW_NOTIFICATION_DEVICE_TOKEN, dictParameters: aDictParams, sucessBlock: { (response) in }, failureBlock: { error in })
        
        // Setup MapView
        //mapView.isMyLocationEnabled = true
        //mapView.settings.myLocationButton = true
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        
        
        
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFromSeller {
            if strDeliveryMode == "1" {
                locationManager.requestWhenInUseAuthorization()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingHeading()
            }
            else {
                fetchRoute()
                buyerLocationReceiver = self
            }
            if SESSION.isRTLEnabled() == true {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
            else {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
        }
        else {
            if strDeliveryMode == "1" {
                fetchRoute()
                buyerLocationReceiver = self
            }
            else {
                
                locationManager.requestWhenInUseAuthorization()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingHeading()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if isFromSeller {
            if strDeliveryMode == "1" {
                locationManager.stopUpdatingLocation()
                locationManager.stopUpdatingHeading()
                locationManager.delegate = nil
                buyerLocationReceiver = nil
            }
        }
        else {
            if strDeliveryMode == "2" {
                locationManager.stopUpdatingLocation()
                locationManager.stopUpdatingHeading()
                locationManager.delegate = nil
                buyerLocationReceiver = nil
            }
        }
        
        super.viewDidDisappear(animated)
    }
    
    func fetchRoute() {
        
        var googleapis = "https://maps.googleapis.com/maps/api/directions/json"
        
        googleapis.append("?origin=\(currentLocation!.latitude),\(currentLocation!.longitude)")
        googleapis.append("&destination=\(destinationLocation!.latitude),\(destinationLocation!.longitude)")
        googleapis.append("&sensor=false")
        googleapis.append("&mode=driving")
        googleapis.append("&key=\(GOOGLE_API_KEY)")
        
        let url = URL(string: googleapis)!
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResponse["routes"] as? [Any] else {
                
                return
            }
            
            guard routes.count > 0, let route = routes[0] as? [String: Any] else {
                return
            }
            
            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            guard let duration = route["legs"] as? [[String: Any]] else {
                
                return
            }
            
            guard let distanceKm = duration[0]["distance"] as? [String: Any] else {
                
                return
            }
            guard let durationTime = duration[0]["duration"] as? [String: Any] else {
                
                return
            }
            self.strDistance = distanceKm["text"] as! String
            
            DispatchQueue.main.async {
                
                self.mapView.clear()
                
                
                let path = GMSPath(fromEncodedPath: polyLineString)
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 3.0
                polyline.map = self.mapView
                if self.isMapLoadedFirsttime == true {
                    let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: self.currentLocation!, coordinate: self.destinationLocation!))
                    self.mapView.moveCamera(cameraUpdate)
                    self.isMapLoadedFirsttime = false
                }
                //let currentZoom = self.mapView.camera.zoom
                //self.mapView.animate(toZoom: currentZoom - 0.3)
                
                
                let myLocation = CLLocation(latitude: self.currentLocation!.latitude, longitude: self.currentLocation!.longitude)
                
                //My buddy's location
                let mydestLocation = CLLocation(latitude: self.destinationLocation!.latitude, longitude: self.destinationLocation!.longitude)
                
                //Measuring my distance to destination (in meters)
                let distance = myLocation.distance(from: mydestLocation)
                
                //Display the result in km
                print(distance)
                
                
                
                
                if self.isFromSeller {
                    if self.strDeliveryMode == "1" {
                        //                    self.myCarMarker.map = nil
                        self.myCarMarker.title = "Current Location"
                        self.myCarMarker.appearAnimation = .pop
                        self.myCarMarker.position = self.currentLocation!
                        
                        self.myCarMarker.icon = UIImage(named: "marker_car")
                        
                        self.myCarMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        self.myCarMarker.rotation = self.rotation
                        
                        self.myCarMarker.map = self.mapView
                        
                        self.destinationMarker.map = nil
                        self.destinationMarker.title = "Destination"
                        self.destinationMarker.appearAnimation = .pop
                        self.destinationMarker.position = self.destinationLocation!
                        self.destinationMarker.icon = UIImage(named: "marker_from")
                        self.destinationMarker.map = self.mapView
                    }
                    else {
                        //                        self.myCarMarker.map = nil
                        self.myCarMarker.title = "Destination"
                        self.myCarMarker.appearAnimation = .pop
                        
                        self.myCarMarker.position = self.destinationLocation!
                        self.myCarMarker.icon = UIImage(named: "marker_car")
                        
                        self.myCarMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        self.myCarMarker.rotation = self.rotation
                        
                        self.myCarMarker.map = self.mapView
                        
                        self.destinationMarker.map = nil
                        self.destinationMarker.title = "Current Location"
                        self.destinationMarker.appearAnimation = .pop
                        self.destinationMarker.position = self.currentLocation!
                        self.destinationMarker.icon = UIImage(named: "marker_from")
                        self.destinationMarker.map = self.mapView
                    }
                }
                else {
                    if self.strDeliveryMode == "1" {
                        //                        self.myCarMarker.map = nil
                        self.myCarMarker.title = "Destination"
                        self.myCarMarker.appearAnimation = .pop
                        self.myCarMarker.position = self.destinationLocation!
                        self.myCarMarker.icon = UIImage(named: "marker_car")
                        
                        self.myCarMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        self.myCarMarker.rotation = self.rotation
                        
                        self.myCarMarker.map = self.mapView
                        
                        self.destinationMarker.map = nil
                        self.destinationMarker.title = "Current Location"
                        self.destinationMarker.appearAnimation = .pop
                        self.destinationMarker.position = self.currentLocation!
                        self.destinationMarker.icon = UIImage(named: "marker_from")
                        self.destinationMarker.map = self.mapView
                        
                    }
                    else {
                        //                        self.myCarMarker.map = nil
                        self.myCarMarker.title = "Current Location"
                        self.myCarMarker.appearAnimation = .pop
                        
                        self.myCarMarker.position = self.currentLocation!
                        
                        self.myCarMarker.icon = UIImage(named: "marker_car")
                        
                        self.myCarMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        self.myCarMarker.rotation = self.rotation
                        
                        
                        self.myCarMarker.map = self.mapView
                        
                        self.destinationMarker.map = nil
                        self.destinationMarker.title = "Destination"
                        self.destinationMarker.appearAnimation = .pop
                        self.destinationMarker.position = self.destinationLocation!
                        self.destinationMarker.icon = UIImage(named: "marker_from")
                        self.destinationMarker.map = self.mapView
                    }
                }
            }
        }).resume()
    }
    
    // MARK: - Button Action
    
    
    
    
    
    // MARK: - Api call
    
    func updateSellerLocation() {
        
        if HELPER.isConnectedToNetwork() {
            
            let dictInfo = ["latitude" : "\(currentLocation!.latitude)", "longitude" : "\(currentLocation!.longitude)", "bearing" : "\(rotation)", "book_id" : strBookingId,"distance" : self.strDistance]
            print(dictInfo)
            HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + "" , dictParameters: dictInfo, sucessBlock: {response in
                self.isLocationUpdated = true
                
                let aIntResponseCode = response["code"] as! Int
                let aMessageResponse = response["message"] as! String
                
                if aIntResponseCode == RESPONSE_CODE_200 {
                    
                }
                else if aIntResponseCode == RESPONSE_CODE_498 {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                        
                        SESSION.setIsUserLogIN(isLogin: false)
                        SESSION.setUserImage(aStrUserImage: "")
                        SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                        SESSION.setUserId(aStrUserId: "")
//                        APPDELEGATE.loadLogInSceen()
                        
                    })
                }
                else {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                }
                
            }, failureBlock: { error in
                
                self.isLocationUpdated = false
            })
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


//MARK: - LocationManager Delegate

extension GSMapDirectionViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        if strDeliveryMode == "1" {
            if isFromSeller && (lastUpdatedTime == nil || lastUpdatedTime?.isTimeLimitReached() == true) {
                currentLocation = location.coordinate
                CATransaction.begin()
                CATransaction.setAnimationDuration(2.0)
                self.myCarMarker.position = currentLocation!
                CATransaction.commit()
                
                fetchRoute()
                
                lastUpdatedTime = Date()
                if isLocationUpdated == true {
                    updateSellerLocation()
                }
                
            }
        }
        else {
            if isFromSeller == false && (lastUpdatedTime == nil || lastUpdatedTime?.isTimeLimitReached() == true) {
                oldcurrentLocation = currentLocation
                currentLocation = location.coordinate
                CATransaction.begin()
                CATransaction.setAnimationDuration(2.0)
                self.myCarMarker.position = currentLocation!
                CATransaction.commit()
                
                fetchRoute()
                
                
                lastUpdatedTime = Date()
                if isLocationUpdated == true {
                    updateSellerLocation()
                }
            }
        }
    }
    
    func updateMarker(coordinates: CLLocationCoordinate2D, duration: Double){
        
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        self.myCarMarker.position = coordinates
        CATransaction.commit()
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fetchApi), userInfo: nil, repeats: false)
        
    }
    @objc func fetchApi() {
        
        fetchRoute()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if isFromSeller {
            if strDeliveryMode == "1" {
                self.rotation = newHeading.trueHeading
                self.myCarMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                self.myCarMarker.rotation = self.rotation
                self.myCarMarker.map = self.mapView
            }
        }
        else {
            if strDeliveryMode == "2" {
                self.rotation = newHeading.trueHeading
                self.myCarMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                self.myCarMarker.rotation = self.rotation
                self.myCarMarker.map = self.mapView
                
            }
        }
    }
    
}

//MARK: - Buyer Location Receiver

extension GSMapDirectionViewController : BuyerLocationReceiver {
    
    func didReceive(location: CLLocationCoordinate2D, rotation: Double) {
        
        olddestinationLocation = destinationLocation
        self.destinationLocation = location
        self.rotation = rotation
        
        updateMarker(coordinates: destinationLocation!, duration: 5.0)
        
        //        self.fetchRoute()
    }
}

//MARK: - Date extension

extension Date {
    
    func isTimeLimitReached() -> Bool {
        let interval = Calendar.current.dateComponents([.second], from: self, to: Date())
        let seconds = interval.second ?? 0
        return (seconds > 7)
    }
}
