//
//  DeviceGroup.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 8/9/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct DeviceGroup: OurCodable {
    static func doConvert() {
        print("do convert")
    }
    
    let id:             Int
    let locationId:     Int
    let name:           String
    let description:    String
    let members:        Int
    let type:           String
    let shared:         Bool
    let isSmartGroup:   Bool
}

