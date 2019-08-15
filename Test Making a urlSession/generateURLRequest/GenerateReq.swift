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
    case updateDeviceProperty(deviceId: String, propertyName: String, propertyValue: String)
    case users, apps, deviceGroups
    case deviceDetail(deviceId: String)
    case userDetail(userId: String)
}

enum GeneratedReq  {
    
    case deviceGroups(path: String, method: HttpMethod, header: [String: String], body: String?)
    case apps(path: String, method: HttpMethod, header: [String: String], body: String?)
    case users(path: String, method: HttpMethod, header: [String: String], body: String?)
    case updateDeviceProperty(path: String, method: HttpMethod, header: [String: String], body: String?)
    case deviceDetail(path: String, method: HttpMethod, header: [String: String], body: String?)
    case userDetail(path: String, method: HttpMethod, header: [String: String], body: String?)
    
    init(request: ValidReqs) {
        
        let headerDict: [String: String] = ["Authorization": "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", "X-Server-Protocol-Version": "2", "Content-Type": "text/plain; charset=utf-8" ]
        

        switch request {
        case .deviceGroups :
            self = .deviceGroups(path: "/devices/groups", method: HttpMethod.get, header: headerDict, body: nil)
        case .users:
            self = .users(path: "/users", method: HttpMethod.get, header: headerDict, body: nil)
        case .apps:
            self = .apps(path: "/apps", method: HttpMethod.get, header: headerDict, body: nil)
        case .updateDeviceProperty(let deviceId, let propertyName, let propertyValue):
            let bodyString = #"""
            {
            "\#(propertyName)": "\#(propertyValue)"
            }
            """#
            self = .updateDeviceProperty(path: "/devices/~~deviceId~~/details".replacingOccurrences(of: "~~deviceId~~", with: deviceId), method: HttpMethod.post, header: headerDict, body: bodyString)
        case .deviceDetail(let deviceId):
            self = .deviceDetail(path: "/devices/\(deviceId)", method: HttpMethod.get, header: headerDict, body: nil)

        case .userDetail(let userId):
            self = .userDetail(path: "/users/\(userId)", method: HttpMethod.get, header: headerDict, body: nil)
        }
    }
    
    fileprivate static let baseURLStr: String = "https://api.zuludesk.com"
    
    /// for urlRequest
    fileprivate static let headerDict: [String: String] = ["Authorization": "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", "X-Server-Protocol-Version": "2", "Content-Type": "text/plain; charset=utf-8" ]
    
    
    fileprivate var generatedPath : String {
        switch self {
        case .apps(let path, _, _, _):
            return path
        case .deviceGroups(let path, _, _, _):
            return path
        case .updateDeviceProperty(let path, _, _, _):
            return path
        case .users(let path, _, _, _):
            return path
        case .deviceDetail(let path, let method, let header, let body):
            return path
        case .userDetail(let path, let method, let header, let body):
            return path
        }
    }
    
    fileprivate var generatedMethod : String {
        switch self {
        case .apps(_ , let method, _, _):
            return method.rawValue
        case .deviceGroups(_ , let method, _, _):
            return method.rawValue
        case .updateDeviceProperty(_ , let method, _, _):
            return method.rawValue
        case .users(_ , let method, _, _):
            return method.rawValue
        case .deviceDetail(let path, let method, let header, let body):
            return method.rawValue
        case .userDetail(let path, let method, let header, let body):
            return method.rawValue

        }
    }
    
    fileprivate var generatedHeader : [String: String] {
        switch self {
        case .apps(_ , _, let header, _):
            return header
        case .deviceGroups(_ , _, let header, _):
            return header
        case .updateDeviceProperty(_ , _, let header, _):
            return header
        case .users(_ , _, let header, _):
            return header
        case .deviceDetail(let path, let method, let header, let body):
            return header
        case .userDetail(let path, let method, let header, let body):
            return header
        }
    }
    
    fileprivate var generatedBody : String? {
        switch self {
        case .apps(_ , _, _, let body):
            return body
        case .deviceGroups(_ , _,  _, let body):
            return body
        case .updateDeviceProperty(_ , _,  _, let body):
            return body
        case .users(_ , _,  _, let body):
            return body
        case .deviceDetail(let path, let method, let header, let body):
            return body
        case .userDetail(let path, let method, let header, let body):
            return body

        }
    }


    fileprivate var generatedURL: URL {
        /// set the base api
        var urlComponents = URLComponents(string: type(of: self).baseURLStr)!
        /// add the path
        urlComponents.path = self.generatedPath
        
        return urlComponents.url!
    }
    
    
    var generatedReq: URLRequest {
        /// create a URL
        let url = self.generatedURL
        
        /// create a URL Request
        var urlRequest = URLRequest(url: url)
        
        /// Set the header
        for ( key, value) in self.generatedHeader {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        /// Set the body
        if let body = generatedBody {
            urlRequest.httpBody = body.data(using: .utf8, allowLossyConversion: true)
            print(body)
        } else {
            print("*** No body ***")
        }
        
        /// Set the method
        urlRequest.httpMethod = self.generatedMethod
                
        
        return urlRequest
    }
    
}



