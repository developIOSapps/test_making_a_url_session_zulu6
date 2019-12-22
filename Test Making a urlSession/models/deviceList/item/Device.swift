//
//  Device.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 8/9/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct Device: OurCodable, NotesUpdateable {
    
    static func doConvert() {
        print("do convert")
    }
    
    let serialNumber      : String
    let UDID              : String
    let name              : String
    let batteryLevel      : Double
    let totalCapacity     : Double
    let lastCheckin       : String
    let modified          : String
    var notes             : String
    var title:          String  { name }
    var picName:        String  { "iPadGraphic"  }
    var identity:       String  { UDID }
}


