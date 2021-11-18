//
//  FBauth.swift
//  Custom Login
//
//  Created by Steven Hertz on 9/16/20.
//  Copyright © 2020 DevelopItSolutions. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

// MARK: - Signin in with email errors

enum FSDataError: Int, Error {
    case invalidEmail        = 17008
    case incorrectPassword   = 17009
    case accoundDoesNotExist = 17011
    case couldNotCreate      = 99
    case extraDataNotCreated = 98
    
    var msg: String {
        switch self {
        case .invalidEmail:
            return "Email not constructed properly "
        case .incorrectPassword:
            return "Incorrect Password"
        case .accoundDoesNotExist:
            return "Account Does Not Exist"
        default:
            return "Unspecified Error"
        }
    }
}
/// done in order to return an integer as an error

struct FBData {
    
    static func getDocument(with user: User,
                            from collection: String = "users",
                            completionHandler: @escaping (Result<DocumentSnapshot,Error>)-> Void ) {
        
        
        let db = Firestore.firestore()
        //        guard let loggedInUser = self.loggedInUser else {fatalError("logged in user prblem ")}
        //        let ui = loggedInUser.uid
        let uEmail = user.email!
        let docRef = db.collection(collection).document(uEmail)
        
        docRef.getDocument { (document, error) in
            
            guard let document = document
                
                else { /* Error happened getting the data*/
                    
                    if let error = error as NSError?
                    {
                        completionHandler(.failure(error))
                        return
                    }
                    else
                    {
                        fatalError("Unexpected result from signon")
                    }
            }

            completionHandler(.success(document))
            
        }
    }
}
