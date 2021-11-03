//
//  HelperStuff.swift
//  download jamfschool student pic
//
//  Created by Steven Hertz on 10/29/21.
//

import Foundation

struct HelperStuf {
    static func getTimeStamp() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        return timestamp
    }
}
