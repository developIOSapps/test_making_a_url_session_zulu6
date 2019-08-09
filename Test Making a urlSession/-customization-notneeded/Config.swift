//
//  Config.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 5/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

// import Foundation

struct Config {
    
    static var shared: Config = Config()
    
    let BASE_URL: String = "http://api.openweathermap.org/data/2.5/weather"
    let API_KEY: String = "ad5ffd719340332d19a70e6202d8b6d2"
    
    fileprivate init() {}

}
