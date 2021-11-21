//
//  LoginViewController.swift
//  Login App




import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    // used to execute the dataRetrevial from the Web API
     var webApiJsonDecoder = WebApiJsonDecoder()
     

    
    //  MARK: -  Screen Objects
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var loggedInUser: User?
    
//    var classGroupCodeInt: Int?
//    var className: String?
//    var apiKey: String?
    
    // MARK: - Properties
    /// to know what class in the array was selected
    let groupIdKeyLiteral = "groupIdKey"
    
    var myApiKey: String? {
        didSet {
            guard let theApiKey = myApiKey else { return  }
            UserDefaultsHelper.setapiKey(theApiKey)
        }
    }
    
    var groupID: Int? {
        didSet {
            guard let groupID = groupID else { return  }
            UserDefaultsHelper.setGroupID(groupID)
        }
    }
    var groupName: String? {
        didSet {
            guard let groupName = groupName else { return  }
            UserDefaultsHelper.setGroupName(groupName)
        }
    }
    var classUUID: String? {
        didSet {
            guard let classUUID = classUUID else { return  }
            UserDefaultsHelper.setClassUUID(classUUID)
        }
    }
    
    
    var schoolClasses: [SchoolClass] = []



    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
//        emailTextField.text = "applereview1@appi4.com"
//        passwordTextField.text = "Simcha@3485"

        
//        if let xx = getGroupId() {
//            print("It is there")
//            doAnimate()
//        } else {
//            getClasses()
//        }
     }
    
    
    // MARK: - Screen Buttons
    @IBAction func loginPressed(_ sender: Any) {

        
        errorLabel.text = ""
        /// Validate fields
        if let error = validateTheFields() {
            showError(error: error)
            return
        }
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("failed in guard")
                return
        }
        
        FBAuth.autheticate(with: email, and: password) { (result) in
            
            guard let authDataResult = try? result.get()
                
                else {   /* This deals with the error */
                    
                    FBAuth.handleAuthError(vc: self, result: result)
                    // self.handleAuthError(result: result)
                    return
                    
                }
            
            /// Is e-mail verified
            let isEmailVerified = authDataResult.user.isEmailVerified
            guard isEmailVerified == true
                
                else {
                    
                    print("not verified - sending e-mail verification")
                    FBAuth.sendEmailVerification(to: authDataResult.user) { (errorFromSendEmail) in
                        
                        guard errorFromSendEmail == nil else  {
                            FBAuth.handleErrorNoResult(vc: self, error: errorFromSendEmail)
                            // self.handleErrorNoResult(error: errorFromSendEmail)
                            self.logUserOff()
                            return
                        }
                        
                        print("sent verification well successfully")
                    }
                    
                    return
            }
            
            print("about to get the data ", authDataResult.user.email)
            self.loggedInUser =  authDataResult.user
            
            FBData.getDocument(with: self.loggedInUser!) { (resultFromFSUserData) in
                guard let theDoc = try? resultFromFSUserData.get()
                    
                    else {   /* This deals with the error */
                        
                        /// Setup to get what we need to process the error
                        guard case Result.failure(let err) = resultFromFSUserData else { fatalError("// this should never execute in getting error") }
                        
                        /// We got what we need and we are ready to process the error
                        print("the error code is \(err)")
                        print("pause")
                        return
                        
                    }
                
                guard let record = theDoc.data(), let apiKey = record["apiKey"] as? String, let classGroupCodeInt = record["classGroupCodeInt"] as? Int, let className = record["className"] as? String else {
                    fatalError("could not convert it to a non optional")
                }
                /// -> Success! - got the document and now can retreive the information
                print("We got the apikey it is \(apiKey) and \(className) and \(classGroupCodeInt) ")
                
                self.groupID = classGroupCodeInt
                self.groupName = className
                self.myApiKey = apiKey
                
                self.performSegue(withIdentifier: "returnFromLoginWithClass", sender: self)
                
             }
        }
        // doAnimate()
    }
    
    @IBAction func doSegue(_ sender: Any) {
        performSegue(withIdentifier: "returnWithClass", sender: nil)
    }
    
    // MARK: - Internal Helper Functions
    fileprivate func doAnimate() -> Void {
        print("About to animate")
        
//        UIView.animate(withDuration: 2.0) {
//            self.view.alpha = 0.15
//        }
        
//        UIView.animate(withDuration: 1.5, animations: {
//            self.view.alpha = 0.05
//        }) { (_) in
//            print("finished animation")
//            // self.dismiss(animated: true, completion: nil)
//        }
        
        UIView.animate(withDuration: 3.5, animations: {
            self.view.alpha = 0.0
        }) { (completed) in
            if completed {
                print("completed")
            }
        }
    }

    
    func saveGroupId(_ groupID: Int, andName name: String) {
        self.groupID = groupID
        // UserDefaults.standard.set(groupID, forKey: "teacherSelected")
        UserDefaultsHelper.setGroupID(groupID)
        self.groupName = name
//        UserDefaults.standard.set(groupID, forKey: groupIdKeyLiteral)
    }
 
    func getGroupId() -> Int? {
        // let groupCode = UserDefaults.standard.integer(forKey: groupIdKeyLiteral)
        let groupCode = UserDefaultsHelper.getGroupID()
        print("- - - the group code is \(groupCode)")
        return groupCode != 0 ? groupCode : nil
    }
}

    extension LoginViewController {
        
        //  MARK: -  setup and process screen elements
        
        func logUserOff()  {
            /// log user off
            do {
                try Auth.auth().signOut()
            } catch  {
                print("logout error", error.localizedDescription)
            }
        }
            
        func setupElements()  {
            
            /// Hide the error label
            errorLabel.alpha = 1
            errorLabel.isHidden = true
            
            /// Style the elements
            Utilities.styleTextField(emailTextField)
            Utilities.styleTextField(passwordTextField)
            Utilities.styleFilledButton(loginButton)
            
        }
        
        func validateTheFields() -> String? {
            
            if  emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                print("Please fill out all fields")
                return "Please fill out all the fields"
            }
            
//            if Utilities.isPasswordValid(passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false {
//                print("Please make sure your password is at least 8 chrachters, contains a special charachter and a number")
//                return " Please make sure your password is at least 8 chrachters, contains a special charachter and a number"
//            }
            
            return nil
        }
        
        func showError(error: String)  {
            errorLabel.text = error
            errorLabel.isHidden = false
        }

}

extension LoginViewController {
    fileprivate func getTheCredentialedData() {
        // Do any additional setup after loading the view.
        
        
        
        /*  1: --------  Authenticate the teaxher  ------------------------------------    */
        let urlValuesForTeacherAuthenticate = URLValues.urlForTeacherAuthenticate
        webApiJsonDecoder.justAuthenticateProcess(with: urlValuesForTeacherAuthenticate.getUrlRequest(), andSession: urlValuesForTeacherAuthenticate.getSession() ) {(result) in
            
            if case  .failure(.httpError(let respne)) = result, respne.statusCode == 401 {
                print("error authi")
                return
            }
            
            
            // *** No errors do the process and get the returned object ***
            
            // get the data from result
            guard let aAuthenticateReturnData = try? result.get() else {fatalError("no data") }
            
            // decode the authenticate data
            let returnFromDecodingAuthentication: Result<AuthenticateReturnObjct,GetResultOfNetworkCallError> = self.webApiJsonDecoder.processTheData(with: aAuthenticateReturnData)
            
            // verify and get the response object
            guard let aAuthenticateReturnObjct = try? returnFromDecodingAuthentication.get() else {
                if case Result<AuthenticateReturnObjct,GetResultOfNetworkCallError>.failure(let getResultOfNetworkCallError) = returnFromDecodingAuthentication {
                    self.webApiJsonDecoder.processTheError(with: getResultOfNetworkCallError)
                }
                return
            }
            
            
            //  *** OK we got the returned object - Use it  ***
            
            self.webApiJsonDecoder.theAuthenticateReturnObjct = aAuthenticateReturnObjct
            guard let userId = self.webApiJsonDecoder.theAuthenticateReturnObjct?.authenticatedAs.id else {fatalError("id error")}
            
            
            
            
            /*  2: --------  Get teacher User info  ------------------------------------    */
            let urlValuesForUserInfo = URLValues.urlForUserInfo(userID: String(userId))
            self.webApiJsonDecoder.sendURLReqToProcess(with: urlValuesForUserInfo.getUrlRequest(), andSession: urlValuesForUserInfo.getSession() ) { (data) in
                
                 // OK we are fine, we got data - so lets write it to a file so we can retieve it
                
                
                // decode the json data
                let returnFromUserInfo: Result<UserInfoReturnObjct,GetResultOfNetworkCallError> = self.webApiJsonDecoder.processTheData(with: data)
                
                guard let aUserInfoReturnObjct = try? returnFromUserInfo.get() else {
                    if case Result<UserInfoReturnObjct,GetResultOfNetworkCallError>.failure(let getResultOfNetworkCallError) = returnFromUserInfo {
                        self.webApiJsonDecoder.processTheError(with: getResultOfNetworkCallError)
                    }
                    return
                }
                self.webApiJsonDecoder.theUserInfoReturnObjct = aUserInfoReturnObjct
                
                // get the class group code
                guard let classGroupCode = aUserInfoReturnObjct.user.teacherGroups.first else {fatalError("There were no classes assigned to this teacher")}
                
                
                
                /*  3: --------  Get list of classes  ------------------------------------    */
                let urlValuesForListOfClasses = URLValues.urlForListOfClasses
                self.webApiJsonDecoder.sendURLReqToProcess(with: urlValuesForListOfClasses.getUrlRequest(), andSession: urlValuesForListOfClasses.getSession()) { data in
                    let returnFromListOfClasses: Result<ClassesReturnObjct,GetResultOfNetworkCallError> = self.webApiJsonDecoder.processTheData(with: data)
                    
                    guard let aClassesReturnObjct = try? returnFromListOfClasses.get() else {
                        if case Result<UserInfoReturnObjct,GetResultOfNetworkCallError>.failure(let getResultOfNetworkCallError) = returnFromUserInfo {
                            self.webApiJsonDecoder.processTheError(with: getResultOfNetworkCallError)
                        }
                        return
                    }
                    
                    self.webApiJsonDecoder.theClassesReturnObjct = aClassesReturnObjct
                    
                    
                    
                    /*  4: --------  Get this teachers class  ------------------------------------    */
                    
                    // first get the class identifier
                    guard let classList = self.webApiJsonDecoder.theClassesReturnObjct?.classes           else {fatalError("could not retreive classes")}
                    guard let idx = classList.firstIndex(where:  { $0.userGroupId == classGroupCode} )    else {fatalError("couldn't find the class group")}
                    let theClass = classList[idx]
                    let classuuid = theClass.uuid
                    
                    
                    let urlValuesForClassInfo = URLValues.urlForClassInfo(UUISString: classuuid)
                    self.webApiJsonDecoder.sendURLReqToProcess(with: urlValuesForClassInfo.getUrlRequest(), andSession: urlValuesForClassInfo.getSession()) { data in
                        let returnFromClassInfo: Result<ClassReturnObjct,GetResultOfNetworkCallError>
                            = self.webApiJsonDecoder.processTheData(with: data)
                        
                        guard let aClassReturnObjct = try? returnFromClassInfo.get() else {
                            if case Result<UserInfoReturnObjct,GetResultOfNetworkCallError>.failure(let getResultOfNetworkCallError)
                                = returnFromUserInfo {
                                self.webApiJsonDecoder.processTheError(with: getResultOfNetworkCallError)
                            }
                            return
                        }
                        
                        self.webApiJsonDecoder.theClassReturnObjct = aClassReturnObjct
                        
                        
                    }
                }
            }
        }
    }

}
