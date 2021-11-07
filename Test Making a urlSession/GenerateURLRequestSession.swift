//
//  GenerateURLRequestSession.swift
//  Getting Dtudent Pic
//
//  Created by Steven Hertz on 11/3/21.
//

import Foundation

enum URLValues {

    // Headers
    static let authorizationValue = "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU="
    static let authorizationName = "Authorization"

    static let xServerProtocolVersionValue = "3"
    static let xServerProtocolVersionName = "X-Server-Protocol-Version"
    
    static let cookieValue = "Hash=f59c9e4a0632aed5aa32c482301cfbc0; hash=78be3e9f9fb5aff8587c93c7a3b3b5f1"
    static let cookieName = "Cookie"
    
    static let urlStringForListOfClasses = "https://api.zuludesk.com/classes"
    static let urlStringForClassInfo = "https://api.zuludesk.com/classes"
    static let urlStringForStudentPic = "https://api.zuludesk.com/classes"

    
    case urlForListOfClasses
    case urlForClassInfo(UUISString: String)
    case urlForStudentPic(picUrlString: String)

    
    func getUrlRequest(with urlString: String? = nil) -> URLRequest {
        
        let myUrl = self.urlforCase
        
        switch self {
        case .urlForListOfClasses:
            break
        case .urlForClassInfo: break
//            if let urlString = urlString {
//                myUrl.appendPathComponent(urlString)
//            }
        case .urlForStudentPic: break
//            guard let urlString = urlString, let urlForStudentPicture = URL(string: urlString) else {fatalError("Could not convert to url") }
//            myUrl = urlForStudentPicture
        }
        
        var request = URLRequest(url: myUrl)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue(URLValues.authorizationValue, forHTTPHeaderField: URLValues.authorizationName)
        request.addValue(URLValues.xServerProtocolVersionValue, forHTTPHeaderField: URLValues.xServerProtocolVersionName)
        request.addValue(URLValues.cookieValue, forHTTPHeaderField: URLValues.cookieName)
        return request
    }
    
    func getSession () -> URLSession  {
         let sessionConfig = URLSessionConfiguration.default
         let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
         return session
     }
    
    var urlforCase: URL {
        
        guard var myUrl = URL(string: Self.urlStringForListOfClasses) else {fatalError("zz")}
        
        switch self {
        
        case .urlForListOfClasses:
            if let  yUrl = URL(string: Self.urlStringForListOfClasses) {
                myUrl = yUrl
            }
            
        case .urlForClassInfo(let UUIDString):
            if let  yUrl = URL(string: Self.urlStringForClassInfo) {
                myUrl = yUrl.appendingPathComponent(UUIDString)
            }
            
        case .urlForStudentPic(let picUrlString):
            if let  yUrl = URL(string: picUrlString) {
                myUrl = yUrl
            }
            
        }
        
        return myUrl

    }    

}
