//
//  User.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 8/9/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct User: OurCodable {
    static func doConvert() {
        print("do convert")
    }
    
    let id:             Int
    let firstName:      String
    let lastName:       String
    var notes:          String

}

