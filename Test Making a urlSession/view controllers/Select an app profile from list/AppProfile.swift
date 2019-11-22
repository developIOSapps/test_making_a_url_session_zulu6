//
//  AppProfile.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/22/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

class AppProfile {
    
    var id: String
    var title: String
    var description: String
    
    init(title: String, description: String) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
    }
    
}

