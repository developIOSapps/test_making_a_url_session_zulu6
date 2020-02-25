//
//  AppCategories.swift
//  Template Categories
//
//  Created by Steven Hertz on 2/12/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import Foundation

enum IconType {
    case system
    case asset
}

class AppCategory {
    
    let key: Int
    var name: String
    var description: String
    var iconName: String
    let iconType: IconType
    
    init(key: Int, name: String, description: String, iconName: String, iconType: IconType) {
        self.key = key
        self.name = name
        self.description = description
        self.iconName = iconName
        self.iconType = iconType
    }
}

