//
//  LoginViewController.swift
//  Login App
//
//  Created by Steven Hertz on 12/1/19.
//  Copyright © 2019 DevelopItSolutions. All rights reserved.
//

import UIKit

enum ClassTeachers: String, CaseIterable {
    case Morah_Ilana
    case Morah_Chaya
    case Morah_Chumi
    case Morah_Shaindy
    case Morah_Gitty
    case Morah_Chaya_Raizy
}

class LoginViewController: UIViewController {
    
    /// to know what class in the array was selected
    
    let groupIdKeyText = "groupIdKey"
    
    var schoolClasses: [SchoolClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
     }
    
    @IBAction func loginPressed(_ sender: Any) {
        // ShowSettings()
        // getClasses()
        doAnimate()

    }
    
    func ShowSettings() {
        let alertController = UIAlertController (title: "Class Selection Required", message: "Please select the class that will be setup", preferredStyle: .actionSheet)
        
        let settingsAction = UIAlertAction(title: "Morah Ilana", style: .default) { (_) -> Void in
            print("Morah Elana")
        }
        
        let settingsAction2 = UIAlertAction(title: "ssss", style: .default) { (action) in
            print(action.title)
        }

        alertController.addAction(settingsAction)
        alertController.addAction(settingsAction2)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        ClassTeachers.allCases.forEach { (item) in
            print(item.rawValue.replacingOccurrences(of: "_", with: " "))
            
            alertController.addAction(UIAlertAction(title: item.rawValue.replacingOccurrences(of: "_", with: " "), style: .default, handler: { (alert) in
                print(alert.title)
            }))
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func doAnimate() -> Void {
        print("About to animate")
        
        UIView.animate(withDuration: 2.0) {
            self.view.alpha = 0.15
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
                        print(self.schoolClasses[theIdx].userGroupId)
                    }
                    
                    actionButtonArray.append(alertAction)
                    alertController.addAction(alertAction)
                }
                self.present(alertController, animated: true, completion: nil)
            }
        }
    
     }
}
