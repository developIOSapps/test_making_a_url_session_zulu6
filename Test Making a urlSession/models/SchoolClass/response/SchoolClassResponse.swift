//
//  GroupResponse.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/14/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

struct SchoolClassResponse: OurCodable {
    static func doConvert() {
        print("do convert")
    }
    
    let code: Int
    let classes: [SchoolClass]
    
    static func loadTheData() -> SchoolClassResponse {
        guard   let url = Bundle.main.url(forResource: "deviceGroups", withExtension: "json"),
                let jsonString = try?  String(contentsOf: url),
                let jsonData = jsonString.data(using: .utf8)
        else { fatalError("could not get file") }
        
        guard let json = try? JSONDecoder().decode(SchoolClassResponse.self, from: jsonData) else {
            fatalError("decoding")
        }
        
        
        return json
        // print(jsonString)
    }
    
}
