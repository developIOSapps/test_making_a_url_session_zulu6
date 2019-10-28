//
//  DeviceListResponse.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/6/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation


struct DeviceListResponse: OurCodable {
    static func doConvert() {
        print("do convert")
    }
    
    let code: Int
    let count: Int
    let devices: [Device]
    
    static func loadTheData() -> DeviceListResponse {
        guard   let url = Bundle.main.url(forResource: "deviceGroups", withExtension: "json"),
                let jsonString = try?  String(contentsOf: url),
                let jsonData = jsonString.data(using: .utf8)
        else { fatalError("could not get file") }
        
        guard let json = try? JSONDecoder().decode(DeviceListResponse.self, from: jsonData) else {
            fatalError("decoding")
        }
        
        
        return json
        // print(jsonString)
    }
    
}


