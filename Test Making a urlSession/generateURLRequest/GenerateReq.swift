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
    case usersInDeviceGroup(parameterDict: [String: String])
}

enum GeneratedReq  {
    
    case deviceGroups(path: String, method: HttpMethod, header: [String: String], body: String?, queryItems: [String: String]?)
    case apps(path: String, method: HttpMethod, header: [String: String], body: String?, queryItems: [String: String]?)
    case users(path: String, method: HttpMethod, header: [String: String], body: String?, queryItems: [String: String]?)
    case updateDeviceProperty(path: String, method: HttpMethod, header: [String: String], body: String?, queryItems: [String: String]?)
    case deviceDetail(path: String, method: HttpMethod, header: [String: String], body: String?, queryItems: [String: String]?)
    case userDetail(path: String, method: HttpMethod, header: [String: String], body: String?, queryItems: [String: String]?)
    case usersInDeviceGroup(path: String, method: HttpMethod, header: [String: String], body: String?, queryItems: [String: String]?)

    init(request: ValidReqs) {
        
        let headerDict: [String: String] = ["Authorization": "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", "X-Server-Protocol-Version": "2", "Content-Type": "text/plain; charset=utf-8" ]
        

        switch request {
        case .deviceGroups :
            self = .deviceGroups(path: "/devices/groups", method: HttpMethod.get, header: headerDict, body: nil, queryItems: nil)
        case .users:
            self = .users(path: "/users", method: HttpMethod.get, header: headerDict, body: nil, queryItems: nil)
        case .apps:
            self = .apps(path: "/apps", method: HttpMethod.get, header: headerDict, body: nil, queryItems: nil)
        case .updateDeviceProperty(let deviceId, let propertyName, let propertyValue):
            let bodyString = #"""
            {
            "\#(propertyName)": "\#(propertyValue)"
            }
            """#
            self = .updateDeviceProperty(path: "/devices/~~deviceId~~/details".replacingOccurrences(of: "~~deviceId~~", with: deviceId), method: HttpMethod.post, header: headerDict, body: bodyString, queryItems: nil)
        case .deviceDetail(let deviceId):
            self = .deviceDetail(path: "/devices/\(deviceId)", method: HttpMethod.get, header: headerDict, body: nil, queryItems: nil)

        case .userDetail(let userId):
            self = .userDetail(path: "/users/\(userId)", method: HttpMethod.get, header: headerDict, body: nil, queryItems: nil)
 
        case .usersInDeviceGroup(let deviceGroupsDictionary):
            self = .usersInDeviceGroup(path: "/users", method: HttpMethod.get, header: headerDict, body: nil, queryItems: deviceGroupsDictionary)
        
//        case .usersInDeviceGroup:
//            self = .usersInDeviceGroup(path: "/users", method: HttpMethod.get, header: headerDict, body: nil, queryItems: ["memberOf": "9,12"])

        }
    }
    
    fileprivate static let baseURLStr: String = "https://api.zuludesk.com"
    
    /// for urlRequest
    fileprivate static let headerDict: [String: String] = ["Authorization": "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", "X-Server-Protocol-Version": "2", "Content-Type": "text/plain; charset=utf-8" ]
    
    
    fileprivate var generatedPath : String {
        switch self {
        case .apps(let path, _, _, _, _):
            return path
        case .deviceGroups(let path, _, _, _, _):
            return path
        case .updateDeviceProperty(let path, _, _, _, _):
            return path
        case .users(let path, _, _, _, _):
            return path
        case .deviceDetail(let path, _, _, _, _):
            return path
        case .userDetail(let path, _, _, _, _):
            return path
        case .usersInDeviceGroup(let path, _, _, _, _):
            return path
        }
    }
    
    fileprivate var generatedMethod : String {
        switch self {
        case .apps(_ , let method, _, _, _):
            return method.rawValue
        case .deviceGroups(_ , let method, _, _, _):
            return method.rawValue
        case .updateDeviceProperty(_ , let method, _, _, _):
            return method.rawValue
        case .users(_ , let method, _, _, _):
            return method.rawValue
        case .deviceDetail(_ , let method, _, _, _):
            return method.rawValue
        case .userDetail(_ , let method, _, _, _):
            return method.rawValue
        case .usersInDeviceGroup(_ , let method, _, _, _):
            return method.rawValue
        }
    }
    
    fileprivate var generatedHeader : [String: String] {
        switch self {
        case .apps(_ , _, let header, _, _):
            return header
        case .deviceGroups(_ , _, let header, _, _):
            return header
        case .updateDeviceProperty(_ , _, let header, _, _):
            return header
        case .users(_ , _, let header, _, _):
            return header
        case .deviceDetail(_ , _, let header, _, _):
            return header
        case .userDetail(_ , _, let header, _, _):
            return header
        case .usersInDeviceGroup(_ , _, let header, _, _):
            return header
        }
    }
    
    fileprivate var generatedBody : String? {
        switch self {
        case .apps(_ , _, _, let body, _):
            return body
        case .deviceGroups(_ , _,  _, let body, _):
            return body
        case .updateDeviceProperty(_ , _,  _, let body, _):
            return body
        case .users(_ , _,  _, let body, _):
            return body
        case .deviceDetail(_ , _,  _, let body, _):
            return body
        case .userDetail(_ , _,  _, let body, _):
            return body
        case .usersInDeviceGroup(_ , _,  _, let body, _):
            return body
        }
    }

    fileprivate var generatedQueryItems :  [String: String]? {
        switch self {
        case .apps(_ , _, _, _, let queryItems):
            return queryItems
        case .deviceGroups(_ , _,  _, _, let queryItems):
            return queryItems
        case .updateDeviceProperty(_ , _,  _, _, let queryItems):
            return queryItems
        case .users(_ , _,  _, _, let queryItems):
            return queryItems
        case .deviceDetail(_ , _,  _, _, let queryItems):
            return queryItems
        case .userDetail(_ , _,  _, _, let queryItems):
            return queryItems
        case .usersInDeviceGroup(_ , _,  _, _, let queryItems):
            return queryItems
        }
    }
    


    fileprivate var generatedURL: URL {
        /// set the base api
        var urlComponents = URLComponents(string: type(of: self).baseURLStr)!
        /// add the path
        urlComponents.path = self.generatedPath
        
        var queryItemsArray = [URLQueryItem]()
        print("******************* about to dump query items")
        dump(self.generatedQueryItems)

        if let queryItems = self.generatedQueryItems {
            for (key, value) in queryItems {
                let item = URLQueryItem(name: key, value: value)
                queryItemsArray.append(item)
                print("***** in query items - \(value)")

            }
        }
        if !queryItemsArray.isEmpty {
            urlComponents.queryItems = queryItemsArray
        }
        
        
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



