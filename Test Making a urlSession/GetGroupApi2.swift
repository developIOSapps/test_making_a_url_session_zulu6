//
//  GetGroupApi2.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/14/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

class GetGroupApi2 {
    var deviceGroupResponse: DeviceGroupResponse = DeviceGroupResponse(deviceGroups: [], code: 1)
    
    init?() {
        
        /// create the request

        /// create a URL
        let url = URL(string: "https://api.zuludesk.com/devices/groups")!

        /// create a URL Request
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", forHTTPHeaderField: "Authorization")


//        var urlRequest : URLRequest = {
//            /// create a URL
//            let url = URL(string: "https://api.zuludesk.com/devices/groups")!
//
//            /// create a URL Request
//            var urlRequest = URLRequest(url: url)
//            urlRequest.addValue("Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", forHTTPHeaderField: "Authorization")
//            return urlRequest
//        }()
        
        var deviceGroupResponsxx: DeviceGroupResponse?

        /// Get the data
        GetDataApi.getZuluDataWrapper(with: urlRequest) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let err):
                print("in the GetDataApi.getZuluDataWrapper in switch error")
                switch err {
                case .decodingError:    print("decoding error")
                case .domainError:      print("domiain error")
                }
                print(err)
                
                
            case .success(let data):
                 print("in the GetDataApi.getZuluDataWrapper in switch success")
                let decoder = JSONDecoder()
                deviceGroupResponsxx = try? decoder.decode(DeviceGroupResponse.self, from: data)
                //deviceGroupResponsxx = deviceGroupResponsx
                //print(deviceGroupResponsxx.deviceGroups[0].name)
                
           }
            
        }
        
        guard let dviceGroupResponse = deviceGroupResponsxx else { return nil }
        
        self.deviceGroupResponse = dviceGroupResponse
        

    }
    

}
