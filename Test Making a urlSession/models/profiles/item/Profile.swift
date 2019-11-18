//
//  Profile.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct Profile: OurCodable {
    static func doConvert() {
        print("do convert")
    }
    
    let id:                 Int
    let name:               String
    let description:        String

}
