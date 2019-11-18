//
//  ProfilesResponse.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct ProfilesResponse: OurCodable {
    static func doConvert() {
        print("do convert")
    }
    
    let profiles: [Profile]
    
    static func loadTheData() -> ProfilesResponse {
        guard   let url = Bundle.main.url(forResource: "deviceGroups", withExtension: "json"),
                let jsonString = try?  String(contentsOf: url),
                let jsonData = jsonString.data(using: .utf8)
        else { fatalError("could not get file") }
        
        guard let json = try? JSONDecoder().decode(ProfilesResponse.self, from: jsonData) else {
            fatalError("decoding")
        }
        
        
        return json
        // print(jsonString)
    }
    
}
