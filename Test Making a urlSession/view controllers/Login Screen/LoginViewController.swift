//
//  LoginViewController.swift
//  Login App




import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    /// to know what class in the array was selected
    let groupIdKeyLiteral = "groupIdKey"
    
    var groupID: Int?
    var groupName: String?
    
    var schoolClasses: [SchoolClass] = []



    // MARK: - Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let xx = getGroupId() {
//            print("It is there")
//            doAnimate()
//        } else {
//            getClasses()
//        }
     }
    
    
    // MARK: - Screen Buttons
    @IBAction func loginPressed(_ sender: Any) {
          getClasses()
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

    fileprivate func getClasses() {
        print("about to get classes")
        
        var actionButtonArray = [UIAlertAction]()
        
        GetDataApi.getSchoolClassListResponse { (xyz) in
            DispatchQueue.main.async {
                guard let clsResponse = xyz as? SchoolClassResponse else {fatalError("could not convert it to Classes")}
                
                self.schoolClasses = clsResponse.classes.filter{$0.name.contains("20 - ") }
                
                /// create the AlertController
                let alertController = UIAlertController (title: "Class Selection Required", message: "Please select the class that will be setup", preferredStyle: .actionSheet)
                self.schoolClasses.forEach { (item) in
                    let alertAction = UIAlertAction(title: item.name, style: .default) { (alert) in
                        guard let theIdx = actionButtonArray.firstIndex(of: alert) else {fatalError()}
                        self.saveGroupId(self.schoolClasses[theIdx].userGroupId, andName: self.schoolClasses[theIdx].name )
                        self.performSegue(withIdentifier: "returnFromLoginWithClass", sender: nil)
                        print(self.schoolClasses[theIdx].userGroupId)
                    }
                    actionButtonArray.append(alertAction)
                    alertController.addAction(alertAction)
                }
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
     }
    
    func saveGroupId(_ groupID: Int, andName name: String) {
        self.groupID = groupID
        self.groupName = name
        UserDefaults.standard.set(groupID, forKey: groupIdKeyLiteral)
    }
 
    func getGroupId() -> Int? {
        let groupCode = UserDefaults.standard.integer(forKey: groupIdKeyLiteral)
        print("the group code is \(groupCode)")
        return groupCode != 0 ? groupCode : nil
    }
}
