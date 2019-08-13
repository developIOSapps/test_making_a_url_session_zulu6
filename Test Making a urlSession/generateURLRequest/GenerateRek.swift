//
//  GenerateRek.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 8/13/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "Get"
    case post = "Post"
}

enum ValidReqs {
    case updateDeviceProperty, users, apps, deviceGroups
}

enum GeneratedReq  {
    
    // TODO: - Change what I have here to init and values make it work
    
//    case deviceGroups = "/devices/groups"
//    case apps = "/apps"
//    case users = "/users"
//    case updateDeviceProperty = "/devices/cf50471c282fa5748a709425ffcd9a88bf9c3df3/details"
    
    case deviceGroups(path: String, method: HttpMethod)
    case apps(path: String, method: HttpMethod)
    case users(path: String, method: HttpMethod)
    case updateDeviceProperty(path: String, method: HttpMethod)
    // case undefined

    
    init(request: ValidReqs) {
        switch request {
        case .deviceGroups :
            self = .deviceGroups(path: "/devices/groups", method: HttpMethod.get)
        case .users:
            self = .users(path: "/users", method: HttpMethod.get)
        case .apps:
            self = .apps(path: "/apps", method: HttpMethod.get)
        case .updateDeviceProperty:
            self = .updateDeviceProperty(path: "/devices/cf50471c282fa5748a709425ffcd9a88bf9c3df3/details", method: HttpMethod.post)
        }
    }
    
//    init(which: String) {
//        switch which {
//        case "deviceGroups" :
//            self = .deviceGroups(path: "/devices/groups")
//        case "users":
//            self = .users(path: "/users")
//        case "apps":
//            self = .apps(path: "/apps")
//        case "updateDeviceProperty":
//            self = .updateDeviceProperty(path: "/devices/cf50471c282fa5748a709425ffcd9a88bf9c3df3/details")
//        default:
//            self = .undefined
//        }
//    }
    
    
    fileprivate static let baseURLStr: String = "https://api.zuludesk.com"
    
    
    /// for urlRequest
    fileprivate static let headerDict: [String: String] = ["Authorization": "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", "X-Server-Protocol-Version": "2", "Content-Type": "text/plain; charset=utf-8" ]
    
    
    fileprivate var generatedPath : String {
        switch self {
        case .apps(let path, _):
            return path
        case .deviceGroups(let path, _):
            return path
        case .updateDeviceProperty(let path, _):
            return path
        case .users(let path, _):
            return path
//        default:
//            break
        }
//        return nil
    }
    
    fileprivate var generatedMethod : String {
        switch self {
        case .apps(_ , let method):
            return method.rawValue
        case .deviceGroups(_ , let method):
            return method.rawValue
        case .updateDeviceProperty(_ , let method):
            return method.rawValue
        case .users(_ , let method):
            return method.rawValue
        }
    }
    

    fileprivate var generatedURL: URL {
        /// set the base api
        var urlComponents = URLComponents(string: type(of: self).baseURLStr)!
        /// add the path
        // guard let path = self.generatedPath else { fatalError("undefined path") }
        urlComponents.path = self.generatedPath
        
        return urlComponents.url!
    }
    
    
    var generatedReq: URLRequest {
        /// create a URL
        let url = self.generatedURL
        
        /// create a URL Request
        var urlRequest = URLRequest(url: url)
        
        for ( key, value) in type(of: self).headerDict {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        
        
        urlRequest.httpMethod = self.generatedMethod
        
        switch self {
        case .updateDeviceProperty:
            print("---- In Update Property")
            // urlRequest.httpMethod = "POST"
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



