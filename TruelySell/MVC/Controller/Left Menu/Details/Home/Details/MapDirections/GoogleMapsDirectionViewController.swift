//
//  GoogleMapsDirectionViewController.swift
//
//  Created by user on 28/03/19.
//  Copyright © 2019 dreams. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMapsDirectionViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var gDestinationLatitude = Double()
    var gDestinationLongitude = Double()
    var gProviderName : String = ""
    
    var mySourceCoordinates = CLLocationCoordinate2D()
    var myDestinationCoordinates = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {

        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: Booking_service.LOCATION.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
        
        // Setup MapView
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        //  drawRouteFrom(source: CLLocationCoordinate2D(latitude: currentLocation.latitude,
        //  longitude: currentLocation.longitude), dst: CLLocationCoordinate2D(latitude: currentLocation.latitude,longitude: currentLocation.longitude))
    }
    
    // MARK: - GMSMapViewDelegate
    
    func drawRouteFrom(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=walking&key=AIzaSyBGaDKO6FrO3F6s_ertwoF5kwoMKlK3upQ")!
        
        //        11.045873, 77.017398
        //        11.037601, 77.001938
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=walking&key=\(GOOGLE_API_KEY)")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        
                        let preRoutes = json["routes"] as! NSArray
                        
//                        print(preRoutes)
//                        print(preRoutes.count)
                        
                        if preRoutes.count > 0 {
                            
                            let routes = preRoutes[0] as! NSDictionary
                            let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                            let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                            
                            DispatchQueue.main.async(execute: {
                                let path = GMSPath(fromEncodedPath: polyString)
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeWidth = 3.0
                                polyline.strokeColor = UIColor.red
                                polyline.map = self.mapView
                            })
                        }
                    }
                } catch {
                    print("parsing error")
                }
            }
        })
        task.resume()
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
            default:
              break
            }
        } else {
        }
        
    }
    
    //MARK: LocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let aLocation = locations.last
        
        if aLocation != nil {
            
            // Stop location manager
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
            
            // set source coordinates
            self.mySourceCoordinates = (aLocation?.coordinate)!
            
            let camera = GMSCameraPosition.camera(withLatitude: self.mySourceCoordinates.latitude, longitude: self.mySourceCoordinates.longitude, zoom: 13.0)
            mapView.animate(to: camera)
            
            // set destination coordinates
            self.myDestinationCoordinates = CLLocationCoordinate2D(latitude: gDestinationLatitude, longitude: gDestinationLongitude)
            //  self.myDestinationCoordinates = CLLocationCoordinate2D(latitude: 19.113934, longitude: 72.938226)
            
            // Setup Markers
            let aSourceMarker = GMSMarker(position: self.mySourceCoordinates)
            aSourceMarker.icon = GMSMarker.markerImage(with: UIColor.green)
            aSourceMarker.title = BookingDetailService.YOUR_LOCATION.titlecontent()
            aSourceMarker.map = self.mapView
            
            let aDestionationMarker = GMSMarker(position: self.myDestinationCoordinates)
            aDestionationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
            aDestionationMarker.title = gProviderName
            aDestionationMarker.map = self.mapView
            
            // Drawing Route
            self.drawRouteFrom(source: mySourceCoordinates, destination: myDestinationCoordinates)
        }
    }
}
