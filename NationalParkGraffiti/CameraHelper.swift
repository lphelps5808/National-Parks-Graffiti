//
//  CameraHelper.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/23/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import Foundation
import MobileCoreServices
import ImageIO
import CoreGraphics

private let _imageResizeFactor: CGFloat = 0.05

struct CameraHelper {
    static func presentCameraOnController(#controller: UIViewController, delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = delegate
            imagePicker.sourceType = .Camera
            imagePicker.mediaTypes = [kUTTypeImage]
            imagePicker.allowsEditing = false
            
            LocationManager.sharedInstanceLM.procureLocation()
            
            controller.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Camera Unavailable", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alert.addAction(action)
            controller.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

extension UIImage {
    func downsampledImage() -> UIImage {
        let size = CGSizeApplyAffineTransform(self.size, CGAffineTransformMakeScale(_imageResizeFactor, _imageResizeFactor))
        let hasAlpha = false
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        self.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}