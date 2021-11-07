//
//  StudentsOfClass.swift
//  download jamfschool student pic
//
//  Created by Steven Hertz on 10/27/21.
//

import Foundation



struct WebApiJsonDecoder {
    
    //  MARK: -  vars for the json decoded objects
    var theClassReturnObjct: ClassReturnObjct?
    var theClassesReturnObjct: ClassesReturnObjct?
    
    // Calls the `ConsumeURLDataRequest.getFromWeb` function and process the returned Result, It then ececuted the completionHandler passing it the Data from the Result
    func getTheClassFromWeb(with urlRequest:URLRequest, andSession session: URLSession, completionHandler:  @escaping (Data) -> Void ) -> Void {
        
        ConsumeURLDataRequest.getFromWeb(sessionToUse: session, urlRequstToUse: urlRequest) { (result) in
            // get the data from the Result type
            guard let data = try? result.get() else {
                if case Result.failure(let error) = result {
                    print("these was an error with getting on-line pic\(error.localizedDescription)")
                }
                return
            }
            completionHandler(data)
            return
        }
    }
    
    // Turns the data into a jsonOnbject
    func processTheData<T: Codable>(with data: Data, doThisWhenFinished compHandler: () -> Void )-> T {
        let decoder = JSONDecoder()
        guard let jsonObject = try? decoder.decode(T.self, from: data) else {fatalError("cc")}

        compHandler()
        return jsonObject
    }
     
}


