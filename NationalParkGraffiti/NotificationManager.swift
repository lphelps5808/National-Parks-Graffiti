//
//  NotificationManager.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/15/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import Foundation

private let _sharedInstance = NotificationManager()
protocol LocationUpdateDelegateProtocol: class, NSObjectProtocol {
    func didReceiveLocationUpdate(notification: NSNotification)
    func didReceiveLocationUpdateError(notification: NSNotification)
}

class NotificationManager {
    
    private var notificationCenter : NSNotificationCenter {
        return NSNotificationCenter.defaultCenter()
    }
    
    class var sharedInstance: NotificationManager {
        return _sharedInstance
    }
    
    func registerForLocationUpdates(observer: LocationUpdateDelegateProtocol) {
        notificationCenter.addObserver(observer, selector: "didReceiveLocationUpdate:", name: kLocationNotification, object: nil)
        notificationCenter.addObserver(observer, selector: "didReceiveLocationUpdateError:", name: kLocationErrorNotification, object: nil)
    }
    
    func deregisterForLocationUpdates(observer: LocationUpdateDelegateProtocol) {
        notificationCenter.removeObserver(observer, name: kLocationNotification, object: nil)
        notificationCenter.removeObserver(observer, name: kLocationErrorNotification, object: nil)
    }

    
}