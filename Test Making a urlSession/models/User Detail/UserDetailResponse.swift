//
//  UserDetailResponse.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 12/10/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation
struct UserDetailResponse: OurCodable {
    static func doConvert() {
        print("do convert")
    }
    
    let code: Int
    let user: JSUser
    
    static func loadTheData() -> UserDetailResponse {
        guard   let url = Bundle.main.url(forResource: "deviceGroups", withExtension: "json"),
                let jsonString = try?  String(contentsOf: url),
                let jsonData = jsonString.data(using: .utf8)
        else { fatalError("could not get file") }
        
        guard let json = try? JSONDecoder().decode(UserDetailResponse.self, from: jsonData) else {
            fatalError("decoding")
        }
        
        
        return json
        // print(jsonString)
    }
    
}
