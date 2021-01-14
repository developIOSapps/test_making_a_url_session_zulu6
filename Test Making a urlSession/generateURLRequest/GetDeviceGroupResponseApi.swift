//
//  GetDataApi.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/13/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case domainError
    case decodingError
    case generalError
}

enum APIError : Error {
    case networkingError(Error)
    case serverError // HTTP 5xx
    case requestError(Int, String) // HTTP 4xx
    case invalidResponse
    case generalError, domainError, decodingError
}

struct GetDataApi {
    
    
    static private var session: URLSession {
        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = 20.0
//        config.timeoutIntervalForResource = 20.0
        let urlSession = URLSession(configuration: config)
        return urlSession
    }
    
    
    static func getUserDetail(_ generatedReq: GeneratedReq , then completion: @escaping (Codable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)
                
            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                print(data.prettyPrintedJSONString)

                let decoder = JSONDecoder()
                guard let UserDetailResponsxx = try? decoder.decode(UserDetailResponse.self, from: data) else {fatalError()}
                guard let usrdtl = UserDetailResponsxx as? UserDetailResponse else {fatalError("could not convert it to Users")}
                completion(usrdtl)
            }
        }
    }

    
    static func getDeviceDetail(_ generatedReq: GeneratedReq , then completion: @escaping (Codable) -> Void )  {
        
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
             case .failure(let error):
                processReturnError(error)

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

    
    static func getClassDetail(_ generatedReq: GeneratedReq , then completion: @escaping (Codable) -> Void )  {
        
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
             case .failure(let error):
                processReturnError(error)

            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                print(data.prettyPrintedJSONString)
                print("we are updating notes")
                
                
                let decoder = JSONDecoder()
                
                guard let classDetailResponsxx = try? decoder.decode(ClassDetailResponse.self, from: data) else {fatalError()}
                guard let cldtl = classDetailResponsxx as? ClassDetailResponse else {fatalError("could not convert it to Users")}
                print("we are up to class detail response response")
                completion(cldtl)
                
            }
        }
    }


    static func updateNoteProperty(_ generatedReq: GeneratedReq , then completion: @escaping () -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)

                
            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                print(data.prettyPrintedJSONString)
                print("we are updating notes")
                completion()
            }
        }
    }

    
    static func updateUserProperty(_ generatedReq: GeneratedReq , then completion: @escaping () -> Void )  {
      
      /// Get the data
      getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
          
          print("in the GetDataApi.getZuluDataWrapper before switch")
         
          switch result {
              
          case .failure(let error):
              processReturnError(error)

              
          case .success(let data):
              print("in the GetDataApi.getZuluDataWrapper in switch success")
              print(data.prettyPrintedJSONString)
              print("we are updating notes")
              completion()
              
          }
      }
  }

    
    static func getSchoolClassListResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.classes), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)

            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                print(data.prettyPrintedJSONString)

                let decoder = JSONDecoder()

                guard let schoolClassResponsxx = try? decoder.decode(SchoolClassResponse.self, from: data) else {fatalError()}
                guard let schoolClss = schoolClassResponsxx as? SchoolClassResponse else {fatalError("could not convert it to Users")}
                print("we are up to schoolClss response")
                completion(schoolClss)
                
            }
        }
    }

    
    static func getProfileListResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.profiles), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)

            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                print(data.prettyPrintedJSONString)

                let decoder = JSONDecoder()

                guard let profilesResponsexx = try? decoder.decode(ProfilesResponse.self, from: data) else {fatalError()}
                guard let profileList = profilesResponsexx as? ProfilesResponse else {fatalError("could not convert it to profiles")}
                print("we are up to schoolClss response")
                completion(profileList)
                
            }
        }
    }

    
    static func getUserListResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.users), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)

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
    
    
    static func getUserListByGroupResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.usersInDeviceGroup(parameterDict: ["memberOf" : "9"])), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)
                
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
    
    
    static func getDeviceListByGroupResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.usersInDeviceGroup(parameterDict: ["groups" : "12"])), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)

            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                //                print(data.prettyPrintedJSONString)
                
                let decoder = JSONDecoder()
                
                guard let deviceListResponsexx = try? decoder.decode(DeviceListResponse.self, from: data) else {fatalError()}
                guard let dvc = deviceListResponsexx as? DeviceListResponse else {fatalError("could not convert it to DeviceList")}
                print("we are up to users response")
                completion(dvc)
                
            }
        }
    }

    
    static func getDeviceListByAssetResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.devicesInAssetTag(parameterDict: ["assettag" : "zzz"])), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)

            case .success(let data):
                print("in the GetDataApi.getZuluDataWrapper in switch success")
                //                print(data.prettyPrintedJSONString)
                
                let decoder = JSONDecoder()
                
                guard let deviceListResponsexx = try? decoder.decode(DeviceListResponse.self, from: data) else {fatalError()}
                guard let dvc = deviceListResponsexx as? DeviceListResponse else {fatalError("could not convert it to DeviceList")}
                print("we are up to users response")
                completion(dvc)
                
            }
        }
    }
    

    static func getDeviceGroupResponse(_ generatedReq: GeneratedReq = GeneratedReq(request: ValidReqs.deviceGroups), then completion: @escaping (OurCodable) -> Void )  {
        
        /// Get the data
        getZuluDataWrapper(with: generatedReq.generatedReq) { (result) in
            
            print("in the GetDataApi.getZuluDataWrapper before switch")
            switch result {
                
            case .failure(let error):
                processReturnError(error)

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
    
    static func processReturnError(_ error: APIError) -> Void  {
        switch error {
        case .networkingError(let error):
            print("A networking error. The error description: \(error.localizedDescription)")
            sendAlert(errorMessgae: "A networking error. The error description: \(error.localizedDescription)")
        case .invalidResponse:
            print("Invalid Response. Either not a HTTPURLResponse or no data")
            sendAlert(errorMessgae: "Invalid Response. Either not a HTTPURLResponse or no data")
        case .requestError(let code, let body):
            print("Request Error. The code is: \(code) and the body is \(body). Error decription is \(HTTPURLResponse.localizedString(forStatusCode: code))")
            sendAlert(errorMessgae: "Request Error. The code is: \(code) and the body is \(body). Error decription is \(HTTPURLResponse.localizedString(forStatusCode: code))")
        case .serverError:
            print("Received a server error")
            sendAlert(errorMessgae: "Received a server error")
            
        default:
            break
        }
        print("in the GetDataApi.getZuluDataWrapper in switch error - \(error)")
    }
    
    static func sendAlert(title: String = "Error In URL Request", errorMessgae msg: String ) {
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        UIApplication.topViewController()?.present(alertVC, animated: true, completion: nil)
    }

    
    // 2
    static func getZuluDataWrapper(with urlRequest: URLRequest,
                                   then completion: @escaping (Result<Data, APIError>) -> Void) {
        
        func getZuluData(with urlRequest: URLRequest, then completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
            let task = session.dataTask(with: urlRequest) { (data, response, err) in
                completion(data, response, err)
            }
            task.resume()
        }
        
        getZuluData(with: urlRequest) { (data, response, err) in
            
            if let error = err {
                DispatchQueue.main.async {
                    completion(.failure(.networkingError(error)))
                }
                return
            }
            
            guard let http = response as? HTTPURLResponse, let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            switch http.statusCode {
            case 200:
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case 400...499:
                let body = String(data: data, encoding: .utf8)
                DispatchQueue.main.async {
                    completion(.failure(.requestError(http.statusCode, body ?? "<no body>")))
                }
            case 500...599:
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                
            default:
                fatalError("Unhandled Error Code")
                
            }
            
//            if let myResponse = response as? HTTPURLResponse {
//                print(myResponse.statusCode)
//                print(HTTPURLResponse.localizedString(forStatusCode: myResponse.statusCode))
//
//                print("************************")
//            }
            
            
//            guard let data = data, err == nil  else {
//
//                if let err = err as NSError?, err.domain == NSURLErrorDomain {
//                    completion(.failure(NetworkError.domainError))
//                } else {
//                    completion(.failure(NetworkError.decodingError))
//                }
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else {fatalError(" Could not convert response to http url response") }
//
//            if response.statusCode == 200 {
//                completion(.success(data))
//            } else {
//                completion(.failure(NetworkError.generalError))
//            }
            
            
            
        }
        
    }
    
    
}
