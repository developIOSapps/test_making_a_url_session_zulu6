//
//  LoginViewController.swift
//  Login App




import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
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
            // UserDefaultsHelper.updateSelectedTeacher(groupID: groupID)
            UserDefaultsHelper.setapiKey(theApiKey)
        }
    }
    
    var groupID: Int? {
        didSet {
            guard let groupID = groupID else { return  }
            // UserDefaultsHelper.updateSelectedTeacher(groupID: groupID)
            UserDefaultsHelper.setGroupID(groupID)
        }
    }
    var groupName: String? {
        didSet {
            guard let groupName = groupName else { return  }
            UserDefaultsHelper.setGroupName(groupName)
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
