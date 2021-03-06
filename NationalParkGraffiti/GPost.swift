//
//  PostModel.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/16/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct GPost {
    var coordinate: CLLocationCoordinate2D
    var imageString: String
    var userID: String
    var userName: String
    var park: String
    var date: NSDate?
    
    static func postsForJSON(json: AnyObject) -> [GPost] {
        var postsArray = [GPost]()
        if let posts = JSON(json).array {
            for post in posts {

                postsArray.append(GPost.postForJSON(post))
            }
        }
        return postsArray
    }
    
    private static func postForJSON(json: JSON) -> GPost {
        let userId = json["user_id"].stringValue
        let imageString = json["image"].stringValue
        let userName = json["user_name"].stringValue
        let park = json["park"].stringValue
        let lat = json["lat"].doubleValue
        let lon = json["lon"].doubleValue
        let coordinate = CLLocationCoordinate2DMake(lat, lon)
        let createdAtDateString = json["created_at"].stringValue
        let createdAtDate = DateFormatter.iso8601DateFormatter.dateFromString(createdAtDateString)
        
        return GPost(coordinate: coordinate, imageString: imageString, userID: userId, userName: userName, park: park, date: createdAtDate)
    }
    
    func parameters() -> [String : AnyObject] {
        return ["g_post" : ["lat" : coordinate.latitude, "lon" : coordinate.longitude, "image" : imageString, "user_id" : userID, "user_name" : userName, "park" : park]]
    }

}
    