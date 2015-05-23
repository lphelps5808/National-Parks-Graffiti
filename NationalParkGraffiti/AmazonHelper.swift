//
//  AmazonHelper.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/23/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import Foundation
import AWSS3

private let _sharedinstance = AmazonHelper()

typealias ImageUploadCompletionBlock = (succes: Bool, error: NSError?) -> ()

class AmazonHelper {
    
    class var sharedInstance : AmazonHelper {
        return _sharedinstance
    }
    
    init() {
        authenticate()
    }
    
    private func authenticate() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: kCognitoRegionType, identityPoolId: kCognitoIdentityPoolId)
        let configuration = AWSServiceConfiguration(region: kDefaultServiceRegionType, credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
    }
    
    private func upload(uploadRequest: AWSS3TransferManagerUploadRequest, completion: ImageUploadCompletionBlock) {
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                if error.domain == AWSS3TransferManagerErrorDomain as String {
                    if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch (errorCode) {
                        case .Cancelled, .Paused:
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                println("wat?")
                            })
                            break;
                            
                        default:
                            println("upload() failed: [\(error)]")
                            break;
                        }
                    } else {
                        println("upload() failed: [\(error)]")
                    }
                } else {
                    println("upload() failed: [\(error)]")
                }
                
                completion(succes: false, error: error)
            }
            
            if let exception = task.exception {
                println("upload() failed: [\(exception)]")
            }
            
            if task.result != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(succes: true, error: nil)
                })
            }
            return nil
        }
    }
    
    func uploadImage(image: UIImage, completion: ImageUploadCompletionBlock) {
        let fileName = NSProcessInfo.processInfo().globallyUniqueString.stringByAppendingString(".png")
        let filePath = NSTemporaryDirectory().stringByAppendingPathComponent("upload").stringByAppendingPathComponent(fileName)
        let imageData = UIImagePNGRepresentation(image)
        imageData.writeToFile(filePath, atomically: true)
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.body = NSURL(fileURLWithPath: filePath)
        uploadRequest.key = fileName
        uploadRequest.bucket = kS3BucketName
        
        upload(uploadRequest, completion: completion)
    }
    
}
