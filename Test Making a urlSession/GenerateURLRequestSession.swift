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

    static let xServerProtocolVersionValueV3 = "3"
    static let xServerProtocolVersionValueV2 = "2"
    static let xServerProtocolVersionName = "X-Server-Protocol-Version"
    
    static let cookieValue = "Hash=f59c9e4a0632aed5aa32c482301cfbc0; hash=78be3e9f9fb5aff8587c93c7a3b3b5f1"
    static let cookieName = "Cookie"
    
    static let ContentTypeValue = "application/json; charset=utf-8"
    static let ContentTypeName = "Content-Type"
    

    
    static let urlStringForListOfClasses = "https://api.zuludesk.com/classes"
    static let urlStringForClassInfo = "https://api.zuludesk.com/classes"
    static let urlStringForStudentPic = "https://api.zuludesk.com/classes"
    static let urlStringForTeacherAuthenticate = "https://api.zuludesk.com/teacher/authenticate"

    
    case urlForListOfClasses
    case urlForClassInfo(UUISString: String)
    case urlForStudentPic(picUrlString: String)
    case urlForTeacherAuthenticate

    
    func getUrlRequest(with urlString: String? = nil) -> URLRequest {
        
        let myUrl = self.urlforCase
                
        var request = URLRequest(url: myUrl)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue(URLValues.authorizationValue, forHTTPHeaderField: URLValues.authorizationName)
        request.addValue(URLValues.cookieValue, forHTTPHeaderField: URLValues.cookieName)
        
        
        switch self {
        case .urlForListOfClasses:  request.addValue(URLValues.xServerProtocolVersionValueV3, forHTTPHeaderField: URLValues.xServerProtocolVersionName)

        case .urlForClassInfo:      request.addValue(URLValues.xServerProtocolVersionValueV3, forHTTPHeaderField: URLValues.xServerProtocolVersionName)

        case .urlForStudentPic:     request.addValue(URLValues.xServerProtocolVersionValueV3, forHTTPHeaderField: URLValues.xServerProtocolVersionName)

        case .urlForTeacherAuthenticate:
            request.addValue(URLValues.xServerProtocolVersionValueV2, forHTTPHeaderField: URLValues.xServerProtocolVersionName)
            request.addValue(URLValues.ContentTypeValue, forHTTPHeaderField: URLValues.ContentTypeName)
            request.httpMethod = "Post"

            // JSON Body

            let bodyObject: [String : Any] = [
                "company": "1049131",
                "username": "morahchumie",
                "password": "Chummie@864"
            ]
            request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        }
        
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
        
        case .urlForTeacherAuthenticate:
            if let  yUrl = URL(string: Self.urlStringForTeacherAuthenticate) {
                myUrl = yUrl
            }
            
            
        }
        
        return myUrl

    }

}
