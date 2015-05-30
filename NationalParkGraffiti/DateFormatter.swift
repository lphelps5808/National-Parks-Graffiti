//
//   DateFormatter.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/30/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import Foundation
import ISO8601DateFormatter

struct DateFormatter {
    static let iso8601DateFormatter = ISO8601DateFormatter()
    
    private static let postDateFormatter = NSDateFormatter()
    private static var postDateFormatterOnceToken: dispatch_once_t = 0
    static func dateStringForDate(date: NSDate) -> String {
        dispatch_once(&postDateFormatterOnceToken, { () -> Void in
            self.postDateFormatter.dateFormat = "LLLL d, y, h:mm a"
        })
        return postDateFormatter.stringFromDate(date)
    }
}