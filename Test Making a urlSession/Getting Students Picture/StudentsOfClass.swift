//
//  StudentsOfClass.swift
//  download jamfschool student pic
//
//  Created by Steven Hertz on 10/27/21.


import Foundation

struct DataTaskInfo {
    
    var myUrlString: String
    
    var xurl: URL {
        guard let url = URL(string: myUrlString) else {fatalError("zz")}
        return url
    }
    
    // Headers
    let authorizationValue = "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU="
    let authorizationName = "Authorization"
    
    let xServerProtocolVersionValue = "3"
    let xServerProtocolVersionName = "X-Server-Protocol-Version"
    
    let cookieValue = "Hash=f59c9e4a0632aed5aa32c482301cfbc0; hash=78be3e9f9fb5aff8587c93c7a3b3b5f1"
    let cookieName = "Cookie"
    
    // Request
    var urlRequest: URLRequest  {
        var request = URLRequest(url: xurl)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue(authorizationValue, forHTTPHeaderField: authorizationName)
        request.addValue(xServerProtocolVersionValue, forHTTPHeaderField: xServerProtocolVersionName)
        request.addValue(cookieValue, forHTTPHeaderField: cookieName)
        return request
    }
    
    // session
    var session: URLSession  {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        return session
    }
    
}

struct OldDataTaskInfo {
    
    var myUrl: URL?
    
    var url: URL {
        // guard let url = URL(string: "https://api.zuludesk.com/classes/3813b0d4-280f-4a3d-ab55-a8274bc9ead6") else {fatalError("zz")}
        // 20 - Morah-Chaya
        guard let url = URL(string: "https://api.zuludesk.com/classes/915c8fd8-3202-4cd3-bc26-5bdf1d58dcd6") else {fatalError("zz")}
        
        return url
    }
    
    // Headers
    let authorizationValue = "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU="
    let authorizationName = "Authorization"
    
    let xServerProtocolVersionValue = "3"
    let xServerProtocolVersionName = "X-Server-Protocol-Version"
    
    let cookieValue = "Hash=f59c9e4a0632aed5aa32c482301cfbc0; hash=78be3e9f9fb5aff8587c93c7a3b3b5f1"
    let cookieName = "Cookie"
    
    // Request
    var urlRequest: URLRequest  {
        guard let url = URL(string: "https://api.zuludesk.com/classes/915c8fd8-3202-4cd3-bc26-5bdf1d58dcd6") else {fatalError("zz")}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue(authorizationValue, forHTTPHeaderField: authorizationName)
        request.addValue(xServerProtocolVersionValue, forHTTPHeaderField: xServerProtocolVersionName)
        request.addValue(cookieValue, forHTTPHeaderField: cookieName)
        return request
    }
    
    var session: URLSession  {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        return session
    }
    
}


class StudentsOfClass {
        
    static let dataTaskInfo: DataTaskInfo = DataTaskInfo(myUrlString: "https://api.zuludesk.com/classes/915c8fd8-3202-4cd3-bc26-5bdf1d58dcd6")
    
    var theClassReturnObject: ClassReturnObject?
    

//    init(dataTaskInfo: DataTaskInfo) {
//        self.dataTaskInfo = dataTaskInfo
//    }
    
    
   // let classReturnObject: ClassReturnObject? // this will hold the the Json return object

    func getTheClassFromWeb(completionHandler:  @escaping () -> Void ) -> Void {
        
        ConsumeURLDataRequest.getFromWeb(sessionToUse: StudentsOfClass.dataTaskInfo.session,
                                         urlRequstToUse: StudentsOfClass.dataTaskInfo.urlRequest)
                                        {  (result) in
            
            // get the data from the Result type
            guard let data = try? result.get() else {
                if case Result.failure(let error) = result {
                    print("these was an error with getting on-line pic\(error.localizedDescription)")
                }
                return
            }
            
            // OK we are fine, we got data - so lets write it to a file so we can retieve it
            let aClassReturnObject = self.processTheData(with: data) {
                print("**** From completion handler")
            }
            self.theClassReturnObject = aClassReturnObject
            // dump(self.theClassReturnObject)
            
            completionHandler()
                                    
            return
        }
    }
     
    fileprivate func processTheData(with data: Data, doThisWhenFinished compHandler: () -> Void )-> ClassReturnObject {
        print("hello")
        print(data)
         let decoder = JSONDecoder()

         // convert the json to a model
         guard let classReturnObject = try? decoder.decode(ClassReturnObject.self, from: data) else {fatalError("cc")}
        
        compHandler()
        
        return classReturnObject
         /*
         theClassReturnObject = classReturnObject
         
         let randomStudent = classReturnObject.class.students.randomElement()
         guard let photoURL = randomStudent?.photo else   { fatalError("could not unwrap url")}
         url = photoURL
         print("this is the updated URL", url.path)
         retreiveDataAsPictureFle(withURL: photoURL, theImageView: studentPic) { data in
             print("hello")
         }
         DispatchQueue.main.async {
             self.tableView.reloadData()
         }
        */
     }

}

class OldStudentsOfClass {
        
    static let dataTaskInfo = OldDataTaskInfo()
    
    var theClassReturnObject: ClassReturnObject?
    

   // let classReturnObject: ClassReturnObject? // this will hold the the Json return object

    func getTheClassFromWeb(completionHandler:  @escaping () -> Void ) -> Void {
        
        ConsumeURLDataRequest.getFromWeb(sessionToUse: StudentsOfClass.dataTaskInfo.session,
                                         urlRequstToUse: StudentsOfClass.dataTaskInfo.urlRequest)
                                        {  (result) in
            
            // get the data from the Result type
            guard let data = try? result.get() else {
                if case Result.failure(let error) = result {
                    print("these was an error with getting on-line pic\(error.localizedDescription)")
                }
                return
            }
            
            // OK we are fine, we got data - so lets write it to a file so we can retieve it
            let aClassReturnObject = self.processTheData(with: data) {
                print("**** From completion handler")
            }
            self.theClassReturnObject = aClassReturnObject
            // dump(self.theClassReturnObject)
            
            completionHandler()
                                    
            return
        }
    }
     
    fileprivate func processTheData(with data: Data, doThisWhenFinished compHandler: () -> Void )-> ClassReturnObject {
        print("hello")
        print(data)
         let decoder = JSONDecoder()

         // convert the json to a model
         guard let classReturnObject = try? decoder.decode(ClassReturnObject.self, from: data) else {fatalError("cc")}
        
        compHandler()
        
        return classReturnObject
         /*
         theClassReturnObject = classReturnObject
         
         let randomStudent = classReturnObject.class.students.randomElement()
         guard let photoURL = randomStudent?.photo else   { fatalError("could not unwrap url")}
         url = photoURL
         print("this is the updated URL", url.path)
         retreiveDataAsPictureFle(withURL: photoURL, theImageView: studentPic) { data in
             print("hello")
         }
         DispatchQueue.main.async {
             self.tableView.reloadData()
         }
        */
     }

}
