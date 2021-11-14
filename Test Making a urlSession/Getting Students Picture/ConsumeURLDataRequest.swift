//
//  ConsumeURLDataRequest.swift
//  download jamfschool student pic
//
//  Created by Steven Hertz on 10/27/21.
//

import Foundation

struct ConsumeURLDataRequest {
    static func getFromWeb(sessionToUse session: URLSession, urlRequstToUse request: URLRequest,  thenWithResultDo completionHandler: @escaping (Result<Data, GetResultOfNetworkCallError>) -> Void)  {
        
        
        /* Start a new Task */
        let task = session.dataTask(with: request)  { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let error = error {
                completionHandler(.failure(.transportError(error)))
                return
            }
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completionHandler(.failure(.httpError(Response: response)))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            completionHandler(.success(data))
            
            
            //              let statusCode = (response as! HTTPURLResponse).statusCode
            //              print("URL Session Task Succeeded: HTTP \(statusCode)")
            //
            //              let result = Result<Data,Error> {
            //                  if let error = error {
            //                      throw error
            //                  } else if let data = data {
            //                      return data
            //                  } else {
            //                      throw URLError.unexpectedError
            //                  }
            //              }
            //              completionHandler(result)
            
        }
        
        task.resume()
        
        session.finishTasksAndInvalidate()
    }
    
    
}
