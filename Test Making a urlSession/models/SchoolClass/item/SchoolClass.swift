//
//  Group.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/14/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct SchoolClass: OurCodable {
    static func doConvert() {
        print("do convert")
    }
    
    let uuid:         String
    let name:         String
    let description:  String
    let userGroupId:  Int

}

