//
//  ViewController.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/3/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationUpdateDelegateProtocol {
    
    @IBAction func cameraDisplay(sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.allowsEditing = false

            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Camera Unavailable", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.sharedInstance.registerForLocationUpdates(self)
        LocationManager.sharedInstanceLM.procureLocation()
    }
    
    func didReceiveLocationUpdate(notification: NSNotification) {
        if let location = notification.userInfo?[kLocationKey] as? CLLocation {
            //handle location
            println(location)
        }
    }
    
    func didReceiveLocationUpdateError(notification: NSNotification) {
        if let error = notification.userInfo?[kLocationErrorKey] as? NSError {
            // handle error
            println(error)
        }
    }
    
    deinit {
        NotificationManager.sharedInstance.deregisterForLocationUpdates(self)
    }

}

