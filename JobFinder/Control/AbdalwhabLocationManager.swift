//
//  AbdalwhabLocationManager.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/6/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import AddressBook
import Contacts

@objc protocol AbdalwhabLocationManagerDelegate : NSObjectProtocol{
    
    @objc func didGetUserLocation(_ userLocation:CLLocation)
    @objc optional func didFailToGetUserLocation(withError error:NSError)
    @objc optional func didUpdateToLocation(_ newLocation:CLLocation,_ oldLocation:CLLocation)
    
}

class AbdalwhabLocationManager : NSObject,CLLocationManagerDelegate {
    
    static var sharedInstance = AbdalwhabLocationManager()
    var delegate : AbdalwhabLocationManagerDelegate?
    
    var locationManager :  CLLocationManager!
    var locationServiceEnabled : Bool = false
    var requestingLocation : Bool = false
    var mostRecentLocation : CLLocation?
    
    struct Region{
        var coordinate: CLLocationCoordinate2D,
        radius: Double,
        identifier: String
    }
    
    
    private override init(){
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        
        if self.didGetUserLocation(){
            self.mostRecentLocation = self.getSavedUserLocation()
        }
        
    }
    
    
    func removeLocationDelegate(){
        
        locationManager?.delegate = self
        AbdalwhabLocationManager.sharedInstance = AbdalwhabLocationManager()
        
    }
    
    
    
    func checkAndRequestAuthorizationAndSettings()->Bool{
        
        return self.checkLocationAuthorization()
        
    }
    
    func checkLocationAuthorization()->Bool{
        
        var locationAuthorized = false;
        let currentAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if currentAuthorizationStatus == .authorizedAlways || currentAuthorizationStatus == .authorizedWhenInUse{
            locationAuthorized = true
        }else if currentAuthorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationAuthorized = false
        }else{
            locationAuthorized = false
            
            let locationAlert = UIAlertController(title:"Warning", message:"Location Privacy Allow", preferredStyle: UIAlertController.Style.alert)
            
            let okayAction = UIAlertAction(title:"Settings", style: .default, handler: {(action) in
                if let url = URL(string: "app-settings:root=LOCATION_SERVICES") {
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            
            let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
            locationAlert.addAction(okayAction)
            locationAlert.addAction(cancelAction)
            self.topMostViewController().present(locationAlert, animated: true, completion: nil)
        }
        
        return locationAuthorized;
    }
    
    
    func locationManager(_ manager:CLLocationManager,didChangeAuthorization status:CLAuthorizationStatus)->Void{
        
        if self.checkLocationAuthorization() {
            self.getUserLocation()
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userCurrentLocation = locations[locations.count-1]
        
        self.mostRecentLocation = userCurrentLocation
        print("\(userCurrentLocation.coordinate.latitude) : \(userCurrentLocation.coordinate.longitude)")
        self.saveUserLocation(userLocation: userCurrentLocation)
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(AbdalwhabLocationManagerDelegate.didGetUserLocation(_:))){
            self.delegate!.didGetUserLocation(userCurrentLocation)
        }
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(AbdalwhabLocationManagerDelegate.didUpdateToLocation(_:_:))){
            self.delegate!.didUpdateToLocation!(locations.first!, locations.last!)
        }
        
        
        self.requestingLocation = false;
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("[LM] \(error.localizedDescription)")
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(AbdalwhabLocationManagerDelegate.didFailToGetUserLocation(withError:))){
            self.delegate!.didFailToGetUserLocation!(withError: error as NSError)
        }
        
        self.requestingLocation = false
    }
    
    
    func getUserLocation()->Void{
        
        self.requestingLocation = true
        if self.checkAndRequestAuthorizationAndSettings() {
            if #available(iOS 9.0, *) {
                locationManager?.requestLocation()
            } else {
            }
        }
    }
    
    
    func startUpdating()->Void{
        
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdating()->Void{
        
        locationManager?.stopUpdatingLocation()
        
    }
    
    
    func region(withRegion geotification: Region) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        return region
    }
    
    func startMonitoring(withRegion regoin: Region) {
        
        guard let loactionManager = locationManager else {
            return
        }
        
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
        }
        
        let region = self.region(withRegion: regoin)
        
        loactionManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(region: Region) {
        
        guard let locationManager = locationManager else {
            return
        }
        
        for regionObjec in locationManager.monitoredRegions {
            guard let circularRegion = regionObjec as? CLCircularRegion, region.identifier == region.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func didGetUserLocation()->Bool{
        
        let didGetUserLocation = UserDefaults.standard.bool(forKey: "didGetUserLocation")
        return didGetUserLocation;
    }
    
    func getSavedUserLocation()->CLLocation?{
        
        if (self.didGetUserLocation()) {
            
            let latitude = UserDefaults.standard.object(forKey: "savedUserLocationLatitude") as? Double
            let longitude = UserDefaults.standard.object(forKey: "savedUserLocationLongitude") as? Double
            
            let userLocation = CLLocation(latitude: latitude!, longitude: longitude!)
            
            return userLocation
        }
        
        return nil
    }
    
    func saveUserLocation(userLocation: CLLocation)->Void{
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "didGetUserLocation")
        userDefaults.set(userLocation.coordinate.latitude, forKey: "savedUserLocationLatitude")
        userDefaults.set(userLocation.coordinate.longitude, forKey: "savedUserLocationLongitude")
    }
    
    func getUserDistanceTo(toLocation:CLLocationCoordinate2D)->Double{
        return self.getUserDistanceFrom(fromLocation: self.mostRecentLocation!.coordinate, to: toLocation)
    }
    
    func getUserDistanceFrom(fromLocation:CLLocationCoordinate2D,to toLocation:CLLocationCoordinate2D)->Double{
        
        let originalLocation = CLLocation(latitude: fromLocation.latitude, longitude: fromLocation.longitude)
        let destinationLocation = CLLocation(latitude: toLocation.latitude, longitude: toLocation.longitude)
        let distanceBetweenLocations = destinationLocation.distance(from: originalLocation)
        
        return distanceBetweenLocations
        
    }
    
    private func topMostViewController()->UIViewController{
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        
        return UIViewController()
    }
    
    
    func reverseGeoCodeUserLocation(location: CLLocation, fillData: ((_ addrees: String, _ userInfo: NSDictionary) -> Void)? ){
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                
                let pm = placemarks![0]
                let addressDictionary = pm.addressDictionary
                
                var city = ""
                var street = ""
                var country = ""
                
                if addressDictionary![String(CNPostalAddressCityKey)] != nil{
                    city = addressDictionary![String(CNPostalAddressCityKey)]! as! String
                    
                }
                if addressDictionary![String(CNPostalAddressStreetKey)] != nil{
                    street = addressDictionary![String(CNPostalAddressStreetKey)]! as! String
                }
                if pm.country != nil{
                    country = pm.country!
                }
                
                let address = "\(city) , \(country) , \(street)"
                
                fillData?(address, ["city": city, "country": country,"street" : street, "latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude] )
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
}
