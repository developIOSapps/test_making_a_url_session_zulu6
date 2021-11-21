//
//  StudentsOfClass.swift
//  download jamfschool student pic
//
//  Created by Steven Hertz on 10/27/21.
//

import Foundation

enum GetResultOfNetworkCallError: Error {
    case transportError(Error) // from error
    case httpError(Response: HTTPURLResponse) // from response
    case noData  // from data
    case decodingError(Error)
    case encodingError(Error)
}

struct WebApiJsonDecoder {
    
    //  MARK: -  vars for the json decoded objects
    var theClassReturnObjct: ClassReturnObjct?
    var theClassesReturnObjct: ClassesReturnObjct?
    var theAuthenticateReturnObjct: AuthenticateReturnObjct?
    var theUserInfoReturnObjct: UserInfoReturnObjct?

    
    // Calls the `ConsumeURLDataRequest.getFromWeb` function and process the returned Result, It then ececuted the completionHandler passing it the Data from the Result
    func sendURLReqToProcess(with urlRequest:URLRequest, andSession session: URLSession, completionHandler:  @escaping (Data) -> Void ) -> Void {
        
        ConsumeURLDataRequest.getFromWeb(sessionToUse: session, urlRequstToUse: urlRequest) { (result) in
            
            
            guard let data = try? result.get() else {
                if case Result<Data, GetResultOfNetworkCallError>.failure(let getResultOfNetworkCallError) = result {
                    processTheError(with: getResultOfNetworkCallError)
                }
                return
            }
            // got the data now lets do the correct process
            let value = String(data: data, encoding: .utf8)
            print(value)

            // get the data from the Result type
//            guard let data = try? result.get() else {
//                if case Result.failure(let error) = result {
//                    print("these was an error with getting on-line pic\(error.localizedDescription)")
//                }
//                return
//            }
            
            completionHandler(data)
            return
        }
    }
    
    // Calls the `ConsumeURLDataRequest.getFromWeb` function and process the returned Result, It then ececuted the completionHandler passing it the Data from the Result
    func justAuthenticateProcess(with urlRequest:URLRequest, andSession session: URLSession, completionHandler:  @escaping  (Result<Data, GetResultOfNetworkCallError>) -> Void ) -> Void {
        
        ConsumeURLDataRequest.getFromWeb(sessionToUse: session, urlRequstToUse: urlRequest) { (result) in
            
            switch result {
                case .failure(.httpError(let respne)) where respne.statusCode == 401 :
                    completionHandler(result)
                    return
                case .success(_):
                    completionHandler(result)
                    return
                default:
                    if case Result<Data, GetResultOfNetworkCallError>.failure(let getResultOfNetworkCallError) = result {
                        processTheError(with: getResultOfNetworkCallError)
                    }
                    return
            }
        }
    }


    
    // Turns the data into a jsonOnbject
    func processTheData<T: Codable>(with data: Data) -> Result<T, GetResultOfNetworkCallError> {
        let decoder = JSONDecoder()
        let rtrn: Result<T, GetResultOfNetworkCallError>
        
        // guard let jsonObject = try? decoder.decode(T.self, from: data) else {fatalError("cc")}
        
        do {
            let jsonObject = try decoder.decode(T.self, from: data)
            rtrn = .success(jsonObject)
        } catch let err {
            rtrn = .failure(.decodingError(err))
        }
        
        return rtrn
    }
    
    
    func processTheError(with getResultOfNetworkCallError: GetResultOfNetworkCallError) {
        switch getResultOfNetworkCallError {
        case .transportError(let error):
            print("Transport Error: ", error.localizedDescription)
        case .httpError(let response) where (300...399).contains(response.statusCode):
            print("Server Error: redirection  httpCode: ", response.statusCode )
        case .httpError(let response) where (400...499).contains(response.statusCode):
            print("Server Error: clientError  httpCode: ", response.statusCode )
        case .httpError(let response) where (500...599).contains(response.statusCode):
            print("Server Error: serverError  httpCode: ", response.statusCode )
        case .httpError(let response):
            print("Server Error: undefined  httpCode: ", response.statusCode )
        case .httpError(let response) where (300...399).contains(response.statusCode):
            print("Server Error httpCode: ")
        case .noData:
            print("noData Error httpCode: ")
        case .decodingError(let decodeError):
            print("decodingError Error httpCode:", decodeError.localizedDescription )
        default:
            break
        }
        return
    }
     
}


