//
//  LocationManager.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/14/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

private let _sharedInstanceLM = LocationManager()
let kLocationKey = "location"
let kLocationErrorKey = "locationError"


final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let clManager = CLLocationManager()
    
    var myCurrentLocation: CLLocation? {
        willSet {
            clManager.stopUpdatingLocation()
        }
        didSet {
            if let myCurrentLocation = myCurrentLocation {
                NSNotificationCenter.defaultCenter().postNotificationName(kLocationNotification, object: self, userInfo: [kLocationKey : myCurrentLocation])
            }
        }
    }
    
    class var sharedInstanceLM: LocationManager {
        return _sharedInstanceLM
    }
    
    private func configure() {
        clManager.delegate = self
        clManager.desiredAccuracy = kCLLocationAccuracyBest
        clManager.distanceFilter = kCLDistanceFilterNone
    }
    
    override init() {
        super.init()
        self.configure()
    }
    
    //MARK: - CLLocation Delegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        myCurrentLocation = locations.last as? CLLocation
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        if error != nil {
            NSNotificationCenter.defaultCenter().postNotificationName(kLocationErrorNotification, object: self, userInfo: [kLocationErrorKey : error])
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        procureLocation()
    }
    
    func procureLocation() {
        if authorized() {
            clManager.startUpdatingLocation()
        }
    }
    
    func authorized() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse:
            return true
        case .NotDetermined:
            clManager.requestWhenInUseAuthorization()
        case .Restricted, .Denied:
            let alert = UIAlertController(title: "Error", message: "Location Tracking Not Enabled",    preferredStyle: UIAlertControllerStyle.Alert)
            let openAction = UIAlertAction(title: "Open Settings", style: .Default, handler: { (action) -> Void in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(openAction)
            alert.addAction(cancelAction)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        default:
            break
        }
        return false
    }
    
}
