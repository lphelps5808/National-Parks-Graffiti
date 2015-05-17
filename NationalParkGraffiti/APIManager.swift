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

typealias PostsCompletionBlock = (posts: [AnyObject]?, error: NSError?) -> ()

class APIManager {
    
    class var sharedInstance: APIManager {
        return _sharedInstance
    }
    
    func procurePosts(completion: PostsCompletionBlock) {
        Alamofire.request(.GET, "\(kBaseAPI)\(kGPostsEndpoint)", parameters: nil, encoding: .URL).responseJSON { (_, reponse, json, error) -> Void in
            println(json)
        }
    }
    
}