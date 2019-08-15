//
//  GetDataApi.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/13/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation


struct GetDataApi {
    
    
    static private var session: URLSession {
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        return urlSession
    }
    
    
    static func getDeviceDetail(_ generatedReq: GeneratedReq , then completion: @escaping (Codable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let err):
                print(err.localizedDescription)
                print("in the GetDataApi.getZuluDataWrapper in switch error")
                switch err {
                case .decodingError:    print("decoding error")
                case .domainError:      print("domiain error")
                case .generalError:     print("HTTP error")
                }
                print(err)
                
                
            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                print(data.prettyPrintedJSONString)
                print("we are updating notes")
                
                
                let decoder = JSONDecoder()
                
                guard let deviceDetailResponsxx = try? decoder.decode(DeviceDetailResponse.self, from: data) else {fatalError()}
                guard let dvdtl = deviceDetailResponsxx as? DeviceDetailResponse else {fatalError("could not convert it to Users")}
                print("we are up to device detail response response")
                completion(dvdtl)
                
            }
        }
    }

    
    static func updateNoteProperty(_ generatedReq: GeneratedReq , then completion: @escaping () -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let err):
                print(err.localizedDescription)
                print("in the GetDataApi.getZuluDataWrapper in switch error")
                switch err {
                case .decodingError:    print("decoding error")
                case .domainError:      print("domiain error")
                case .generalError:     print("HTTP error")
                }
                print(err)
                
                
            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                print(data.prettyPrintedJSONString)
                print("we are updating notes")
                completion()
                
            }
        }
    }
    

    
    
    static func getUserListResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.users), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let err):
                print("in the GetDataApi.getZuluDataWrapper in switch error")
                switch err {
                case .decodingError:    print("decoding error")
                case .domainError:      print("domiain error")
                case .generalError:     print("HTTP error")
                }
                print(err)
                
                
            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
//                print(data.prettyPrintedJSONString)

                let decoder = JSONDecoder()

                guard let userResponsxx = try? decoder.decode(UserResponse.self, from: data) else {fatalError()}
                guard let usr = userResponsxx as? UserResponse else {fatalError("could not convert it to Users")}
                print("we are up to users response")
                completion(usr)
                
            }
        }
    }
    
    
    
    
    static func getDeviceGroupResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.deviceGroups), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let err):
                print("in the GetDataApi.getZuluDataWrapper in switch error")
                switch err {
                case .decodingError:    print("decoding error")
                case .domainError:      print("domiain error")
                case .generalError:     print("HTTP error")
                }
                print(err)
                
                
            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                let decoder = JSONDecoder()
                
                guard let deviceGroupResponsxx = try? decoder.decode(DeviceGroupResponse.self, from: data) else {fatalError()}
                guard let dvcg = deviceGroupResponsxx as? DeviceGroupResponse else {fatalError("could not vonvert it to devicegroup")}
                print("we are up to device group response")
                completion(dvcg)
                
            }
        }
    }
    
    
    // 2
    static func getZuluDataWrapper(with urlRequest: URLRequest,
                                   then completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        func getZuluData(with urlRequest: URLRequest,
                                then completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
            
            /// create a data session
            let task = session.dataTask(with: urlRequest) { (data, response, err) in
                completion(data, response, err)
            }
            task.resume()
        }
        
        
        
        getZuluData(with: urlRequest) { (data, response, err) in
            
            if let myResponse = response as? HTTPURLResponse {
                print(myResponse.statusCode)
                print(HTTPURLResponse.localizedString(forStatusCode: myResponse.statusCode))

                print("************************")
            }
            
            
            guard let data = data, err == nil  else {
    
                if let err = err as NSError?, err.domain == NSURLErrorDomain {
                    completion(.failure(NetworkError.domainError))
                } else {
                    completion(.failure(NetworkError.decodingError))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {fatalError(" Could not convert response to http url response") }
            
            if response.statusCode == 200 {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.generalError))
            }
            
            
            
        }
        
    }
    
    
}
