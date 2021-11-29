//
//  MyTabBarController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 12/22/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit


class MyTabBarController: UITabBarController, UITabBarControllerDelegate, TabBarPropertySaver {
   
    var myValue: Int?
    var schoolInfo: SchoolInfo?
    var mdmStatus: MDMStatus?
    var classUUID: String!
    var classGroupCodeInt: Int!
    var locationId: Int!
    var className: String!
    var getAStudentPicture: GetAStudentPicture!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let myTabBarItem0 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem0.image = UIImage(named: "students")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem0.selectedImage = UIImage(named: "students")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        myTabBarItem0.title = "Students"
        
        let myTabBarItem1 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "ipad_mini")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "ipad_mini")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        myTabBarItem1.title = "Devices"
        
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("item is selected  - ",self.selectedIndex )
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("~~~*~~~ view controller is selected - ",self.selectedIndex )
        
        let nav = viewController as! UINavigationController
        let vc = nav.topViewController as! StudentCollectionViewController
        
        vc.tabBarController?.tabBar.isHidden = false
        
        if self.selectedIndex == 0 {
            vc.itemsToDisplay = .students
        } else {
            vc.itemsToDisplay = .devices
        }
    }
}

extension MyTabBarController {
        
    func restoreTheInfo(vc: UIViewController) {
        guard let vc = vc as? StudentCollectionViewController else { return}
        guard let mdmStatus = self.mdmStatus, MDMStatus.fromLoginVC == mdmStatus else {return}

        vc.schoolInfo = schoolInfo
        vc.mdmStatus = mdmStatus
        vc.getAStudentPicture = getAStudentPicture
        vc.classGroupCodeInt = classGroupCodeInt
        vc.locationId = locationId
                
        
        vc.classUUID = classUUID
        vc.className = className

    }
    
    
    func saveTheInfo(vc: UIViewController) {
        guard let vc = vc as? StudentCollectionViewController else { return}
        guard let schoolInfo = vc.schoolInfo else { return }

        self.schoolInfo         = schoolInfo
        self.mdmStatus          = vc.mdmStatus
        self.getAStudentPicture = vc.getAStudentPicture
        self.locationId           = vc.locationId

        self.classGroupCodeInt  = vc.classGroupCodeInt
        self.classUUID          = vc.classUUID
        self.className          = vc.className

        
    }
    

    
}


