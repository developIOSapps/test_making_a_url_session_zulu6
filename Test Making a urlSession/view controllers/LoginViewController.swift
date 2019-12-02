//
//  LoginViewController.swift
//  Login App
//
//  Created by Steven Hertz on 12/1/19.
//  Copyright © 2019 DevelopItSolutions. All rights reserved.
//

import UIKit

enum Direction: Int, CaseIterable {
  case left = 1
  case right
  case up
  case down
}

enum ClassTeachers: String, CaseIterable {
    case Morah_Ilana
    case Morah_Chaya
    case Morah_Chumi
    case Morah_Shaindy
    case Morah_Gitty
    case Morah_Chaya_Raizy
}

class LoginViewController: UIViewController {
    
    let groupIdKeyText = "groupIdKey"
    
    var schoolClasses: [SchoolClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
 
//        print(Direction.allCases.count)
//        // 4
//        Direction.allCases.forEach { print($0.rawValue) }
//        // left right up down.
//
//        ClassTeachers.allCases.forEach { (item) in
//            print(item.rawValue.replacingOccurrences(of: "_", with: " "))
//        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        // ShowSettings()
        getClasses()

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
    
    
    
    
    
    fileprivate func getClasses() {
        print("about to get classes")
        
        GetDataApi.getSchoolClassListResponse { (xyz) in
            DispatchQueue.main.async {
                guard let clsResponse = xyz as? SchoolClassResponse else {fatalError("could not convert it to Classes")}

                self.schoolClasses = clsResponse.classes.filter{$0.name.hasPrefix("20") }
                
                /// create the AlertController
                let alertController = UIAlertController (title: "Class Selection Required", message: "Please select the class that will be setup", preferredStyle: .actionSheet)
                
                self.schoolClasses.forEach { (item) in
                    
                    alertController.addAction(UIAlertAction(title: item.name, style: .default, handler: { (alert) in
                        
                        let idx = self.schoolClasses.firstIndex { (schoolClass) -> Bool in
                            schoolClass.name == alert.title
                        }
                        guard let theIdx = idx else {fatalError("Fatal Error: Could not find the selected class")}
                        print(self.schoolClasses[theIdx].userGroupId)
                    }  )  )
                }

                self.present(alertController, animated: true, completion: nil)

            }
        }
        
        /*
        let alertController = UIAlertController (title: "Class Selection Required", message: "Please select the class that will be setup", preferredStyle: .actionSheet)
        
        schoolClasses.forEach { (item) in
            print(item.name)
            
            alertController.addAction(UIAlertAction(title: item.name, style: .default, handler: { (alert) in
                print(alert.title)
            }))
        }

        present(alertController, animated: true, completion: nil)
    */
    }
    


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
