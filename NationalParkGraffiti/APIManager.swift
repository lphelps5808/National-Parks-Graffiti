//
//  APIManager.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/16/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import Foundation
import Alamofire


private let kBaseAPI = "http://localhost:3000/"
private let kGPostsEndpoint = "g_posts"

private let _sharedInstance = APIManager()

typealias PostsCompletionBlock = (posts: [GPost]?, error: NSError?) -> ()

class APIManager {
    
    class var sharedInstance: APIManager {
        return _sharedInstance
    }
    
    //what would this look like if we didn't use alamaofire?
    
    // pre ios 7 == NSURLConnection
    // iOS7+ == NSURLSession
    
    func procurePosts(completion: PostsCompletionBlock) {
        Alamofire.request(.GET, "\(kBaseAPI)\(kGPostsEndpoint)", parameters: nil, encoding: .URL).responseJSON { (_, reponse, json, error) -> Void in
            if let error = error {
                completion(posts: nil, error: error)
            } else {
                if let json: AnyObject = json {
                    let postsArray = GPost.postsForJSON(json)
                    completion(posts: postsArray, error: nil)
                } else {
                    let e = NSError(domain: "com.laura", code: -1, userInfo: nil)
                    completion(posts: nil, error: e)
                }
            }
        }
    }
    
}