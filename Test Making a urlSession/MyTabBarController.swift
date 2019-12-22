//
//  MyTabBarController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 12/22/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit


class MyTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
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


