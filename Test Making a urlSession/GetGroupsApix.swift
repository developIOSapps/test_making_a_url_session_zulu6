//
//  GetGroupsApi.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/13/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

class GetGroupsApix {
    
    /// function initiating getting the data
    static func toGetZuluData() {
        
        /// create the request
        
        /// create a URL
        let url = URL(string: "https://api.zuludesk.com/devices/groups")!
        
        /// create a URL Request
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", forHTTPHeaderField: "Authorization")
        
        
        
        /// Get the data
        GetDataApi.getZuluDataWrapper(with: urlRequest) { (result) in
            
            switch result {
                
            case .success(let data):
                
                let jsonStr: NSString = {
                    guard   let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []),
                        let prettyData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [.prettyPrinted]),
                        let jsonStr = NSString(data: prettyData, encoding: String.Encoding.utf8.rawValue)
                        else {fatalError()}
                    
                    return jsonStr
                }()
                print(jsonStr)
                
                let decoder = JSONDecoder()
                guard let deviceGroupResponse = try? decoder.decode(DeviceGroupResponse.self, from: data) else { fatalError("could not decpde it")}
                print(deviceGroupResponse.deviceGroups[0].name)
                
                
            case .failure(let err):
                switch err {
                case .decodingError:    print("decoding error")
                case .domainError:      print("domiain error")
                }
                print(err)
            }
            
        }
        
    }

}
