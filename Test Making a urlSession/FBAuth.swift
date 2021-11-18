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


struct FirebaseErrorMsgs {
    
    static let codeDict =
        [
            98:     "Extra data not created",
            99:     "Could not create ",
            17005:  "the user account has been disabled by an administrator",
            17006:  "the given sign-in provider is disabled for this Firebase project",
            17007:  "e-mail already in use",
            17008:  "Email not constructed properly",
            17009:  "Incorrect Password",
            17011:  "firebase cannot find an account with the email address the user specified",
            17014:  "updating a user’s password is a security sensitive operation that requires a recent login from the user",
            17021:  "the user’s credential is no longer valid, the user must sign in again",
            17026:  "the given password is invalid, i.e. the password should at least consist of six characters",
            17031:  "an invalid payload",
            17032:  "an invalid sender email is set in the console for this action",
            17033:  "an invalid recipient email was sent in the request"
    ]
}

enum AuthError: Int, Error {
    case extraDataNotCreated    = 98
    case couldNotCreate         = 99
    case userDisabled           = 17005
    case operationNotAllowed    = 17006
    case emailAlreadyInUse      = 17007
    case invalidEmail           = 17008
    case incorrectPassword      = 17009
    case userNotFound           = 17011
    case requiresRecentLogin    = 17014
    case userTokenExpired       = 17021
    case weakPassword           = 17026
    case invalidMessagePayLoad  = 17031
    case invalidSender          = 17032
    case invalidRecipientEmail  = 17033

    var messg: String {
        return "\(self.rawValue) - " + (FirebaseErrorMsgs.codeDict[self.rawValue] ?? "PLain Error" )
    }
}

//
//enum EmailSigninAuthError: Int, Error {
//    case invalidEmail        = 17008
//    case incorrectPassword   = 17009
//    case accoundDoesNotExist = 17011
//    case couldNotCreate      = 99
//    case extraDataNotCreated = 98
//
//    var messg: String {
//        return "\(self.rawValue) - " + (FirebaseErrorMsgs.codeDict[self.rawValue] ?? "PLain Error" )
//    }
//
//    var msg: String {
//        switch self {
//        case .invalidEmail:
//            return "Email not constructed properly "
//        case .incorrectPassword:
//            return "Incorrect Password"
//        case .accoundDoesNotExist:
//            return "Account Does Not Exist"
//        default:
//            return "Unspecified Error"
//        }
//    }
//}
//
//enum EmailSignupAuthError: Int, Error {
//    case invalidEmail        = 17008
//    case emailAlreadyInUse   = 17007
//    case weakPassword        = 17026
//    case couldNotCreate      = 99
//    case extraDataNotCreated = 98
//
//    var msg: String {
//        switch self {
//        case .invalidEmail:
//            return "Email not constructed properly "
//        case .emailAlreadyInUse:
//            return "Incorrect Password"
//        case .weakPassword:
//            return "Account Does Not Exist"
//        default:
//            return "Unspecified Error"
//        }
//    }
//}
//
//
//enum ResettingPasswordError: Int, Error {
//    case invalidEmail           = 17008
//    case userNotFound           = 17011
//    case weakPassword           = 17026
//    case invalidRecipientEmail  = 17033
//    case invalidSender          = 17032
//    case invalidMessagePayLoad  = 17031
//    case couldNotCreate         = 99
//    case extraDataNotCreated    = 98
//
//    var msg: String {
//        switch self {
//        case .invalidEmail:
//            return "Email not constructed properly "
//        case .userNotFound:
//            return "Firebase cannot find an account with the email address the user specified"
//        case .weakPassword:
//            return "Account Does Not Exist"
//        case .invalidRecipientEmail:
//            return "an invalid recipient email was sent in the request"
//        case .invalidSender:
//            return "an invalid sender email is set in the console for this action"
//        case .invalidMessagePayLoad:
//            return "an invalid email template for sending update email"
//
//        default:
//            return "Unspecified Error"
//        }
//    }
//}
//
//
//enum UpdatingUserPasswordError: Int, Error {
//    case userDisabled           = 17005
//    case weakPassword           = 17026
//    case operationNotAllowed  = 17006
//    case requiresRecentLogin          = 17014
//    case userTokenExpired  = 17021
//    case couldNotCreate         = 99
//    case extraDataNotCreated    = 98
//
//    var msg: String {
//        switch self {
//        case .userDisabled:
//            return "the user account has been disabled by an administrator"
//        case .weakPassword:
//            return "the given password is invalid, i.e. the password should at least consist of six characters"
//        case .operationNotAllowed:
//            return "the given sign-in provider is disabled for this Firebase project"
//        case .requiresRecentLogin:
//            return "updating a user’s password is a security sensitive operation that requires a recent login from the user"
//        case .userTokenExpired:
//            return "the user’s credential is no longer valid, the user must sign in again"
//        default:
//            return "Unspecified Error"
//        }
//    }
//}
//

/// done in order to return an integer as an error
extension Int: Error {}

struct FBAuth {
    
    var delegate: LoginViewController?
    
    static func autheticate(with email: String,
                            and password: String,
                            completionHandler: @escaping (Result<AuthDataResult,Int>)-> Void ) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            /// Make sure got expected result either a valid error or data result
            guard authDataResult != nil || error is NSError else {
                fatalError("Unexpected result from signon")
            }
            
            /// if error return the error code
            if let error = error as NSError? {
                completionHandler(.failure(error.code))
            }
            /// if good return the result
            else
            {
                completionHandler(.success(authDataResult!))
            }
        }
    }
    
    
    static func sendEmailVerification(to user: User, completionHandler: @escaping (Error?)-> Void ) {
        user.sendEmailVerification { (error) in
            
            if let error = error as NSError? {
                completionHandler(error)
            }
                
            else
            {
                completionHandler(nil)
            }
        }
    }
    
    
    static func resetPasswordPressed(withEmail: String, completionHandler: @escaping (Error?)-> Void ) {
        Auth.auth().sendPasswordReset(withEmail: withEmail) { (error) in
            
            if let error = error as NSError? {
                completionHandler(error)
            }
                
            else
            {
                completionHandler(nil)
            }
        }
        
    }
    
    
    
    //  MARK: -  Handle Errors in authentication

    static func handleAuthError(vc: LoginViewController, result: Result<AuthDataResult,Int>)  {
                            /// Setup to get what we need to process the error
        guard case Result.failure(let failureCode) = result else { fatalError("// this should never execute in getting error") }
        
        /// We got what we need and we are ready to process the error
        print("the error code is \(failureCode)")
        print(AuthError(rawValue: failureCode)?.messg ?? "Error - Undefined Code: \(failureCode)")
        // vc.showError(error: AuthError(rawValue: failureCode)?.messg ?? "Error - Undefined Code: \(failureCode)")
        print("pause")
        //  FIXME: -  Check if the e-mail is valid but does not exist yet and give the message to register
    }
    
    static func handleErrorNoResult(vc: LoginViewController, error: Error?)  {
        if let err = error as NSError? {
            print(AuthError(rawValue: err.code)?.messg ?? "Error - Undefined Code: \(err.code)")
           //  vc.showError(error: AuthError(rawValue: err.code)?.messg ?? "Error - Undefined Code: \(err.code)")
            print("pause")
        }
    }

    
}

