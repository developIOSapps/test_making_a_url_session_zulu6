//
//  GenerateURLRequestSessionx.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/24/21.
//  Copyright © 2021 DIA. All rights reserved.
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
    static let urlStringForUserInfo = "https://api.zuludesk.com/users"

    
    case urlForListOfClasses(apiKey: String)
    case urlForClassInfo(UUISString: String, apiKey: String)
    case urlForStudentPic(picUrlString: String, apiKey: String)
    case urlForTeacherAuthenticate(username: String, userPassword: String, apiKey: String, CompanyID: Int)
    case urlForUserInfo(userID: String, apiKey: String)
    
    func getUrlRequest(with urlString: String? = nil) -> URLRequest {
        
        let myUrl = self.urlforCase
                
        var request = URLRequest(url: myUrl)
        request.httpMethod = "GET"
        
        // Headers
        
   //     guard let theApiKey = SchoolInfo.getApiKey() else { fatalError("could not get the apikey")}
        
 //       request.addValue(theApiKey, forHTTPHeaderField: URLValues.authorizationName)
//        request.addValue(URLValues.authorizationValue, forHTTPHeaderField: URLValues.authorizationName)
       request.addValue(URLValues.cookieValue, forHTTPHeaderField: URLValues.cookieName)
        
        
        switch self {
        
        case .urlForListOfClasses(let theApiKey):
            request.addValue(theApiKey, forHTTPHeaderField: URLValues.authorizationName)
            request.addValue(URLValues.xServerProtocolVersionValueV3, forHTTPHeaderField: URLValues.xServerProtocolVersionName)

        case .urlForClassInfo(_, let theApiKey):
            request.addValue(theApiKey, forHTTPHeaderField: URLValues.authorizationName)
            request.addValue(URLValues.xServerProtocolVersionValueV3, forHTTPHeaderField: URLValues.xServerProtocolVersionName)

        case .urlForStudentPic(_, let theApiKey):
            request.addValue(theApiKey, forHTTPHeaderField: URLValues.authorizationName)
            request.addValue(URLValues.xServerProtocolVersionValueV3, forHTTPHeaderField: URLValues.xServerProtocolVersionName)
            
        case .urlForUserInfo(_, let theApiKey):
            request.addValue(theApiKey, forHTTPHeaderField: URLValues.authorizationName)
            request.addValue(URLValues.xServerProtocolVersionValueV3, forHTTPHeaderField: URLValues.xServerProtocolVersionName)
            

        case .urlForTeacherAuthenticate(let username, let userPassword, let theApiKey, let CompanyID):
            print("@@@@ the user name is \(username) and password is \(userPassword)")
            request.addValue(theApiKey, forHTTPHeaderField: URLValues.authorizationName)
            request.addValue(URLValues.xServerProtocolVersionValueV2, forHTTPHeaderField: URLValues.xServerProtocolVersionName)
            request.addValue(URLValues.ContentTypeValue, forHTTPHeaderField: URLValues.ContentTypeName)
            request.httpMethod = "Post"
            print("@@@@ the user name is \(theApiKey) and password is \(userPassword)")

            // JSON Body
        
            let bodyObject: [String : Any] = [
                "company": String(CompanyID),
                "username": username,
                "password": userPassword
            ]
 
           
            /*

            let bodyObject: [String : Any] = [
                "company": "1049131",
                "username": "morahchumie",
                "password": "Chummie@864"
            ]
             */
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
            
        case .urlForClassInfo(let UUIDString,_):
            if let  yUrl = URL(string: Self.urlStringForClassInfo) {
                myUrl = yUrl.appendingPathComponent(UUIDString)
            }
            
        case .urlForStudentPic(let picUrlString, _):
            if let  yUrl = URL(string: picUrlString) {
                myUrl = yUrl
            }
        
        case .urlForTeacherAuthenticate:
            if let  yUrl = URL(string: Self.urlStringForTeacherAuthenticate) {
                myUrl = yUrl
            }
            
        case .urlForUserInfo(let UserId, _):
             if let  yUrl = URL(string: Self.urlStringForUserInfo) {
                 myUrl = yUrl.appendingPathComponent(UserId)
             }
             
            
        }
        
        return myUrl

    }

}
