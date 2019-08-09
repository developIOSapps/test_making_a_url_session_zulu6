//
//  GenerateReq.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/28/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

enum GeneratedReq: String {
    case deviceGroups = "/devices/groups"
    case apps = "/apps"
    case users = "/users"
    case updateDeviceProperty = "/devices/cf50471c282fa5748a709425ffcd9a88bf9c3df3/details"
    
    
    fileprivate static let baseURLStr: String = "https://api.zuludesk.com"

   
    /// for urlRequest
    fileprivate static let headerDict: [String: String] = ["Authorization": "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", "X-Server-Protocol-Version": "2", "Content-Type": "text/plain; charset=utf-8" ]
    
 
   
    
    fileprivate var GeneratedURL: URL {
        /// set the base api
        var urlComponents = URLComponents(string: type(of: self).baseURLStr)!
        /// add the path
        urlComponents.path = self.rawValue
        
        return urlComponents.url!
    }
    
    
    var generatedReq: URLRequest {
        /// create a URL
        let url = self.GeneratedURL
        
        /// create a URL Request
        var urlRequest = URLRequest(url: url)
        
        for ( key, value) in type(of: self).headerDict {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        
        
        urlRequest.httpMethod = "GET"
        
        switch self {
        case .updateDeviceProperty:
            print("---- In Update Property")
            urlRequest.httpMethod = "POST"
            // Body
            let whatToDo = "SECONDHALF"
            let bodyString = "{\n  \"notes\": \"\(whatToDo)\"\n}\n"
            urlRequest.httpBody = bodyString.data(using: .utf8, allowLossyConversion: true)


        default:
            print("---- Not In Update Property")
        }
        
        
        return urlRequest
    }
    
}


