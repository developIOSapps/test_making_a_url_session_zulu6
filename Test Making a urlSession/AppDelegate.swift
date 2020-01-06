//
//  AppDelegate.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 5/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var navigationBarAppearace = UINavigationBar.appearance()

        registerDefaultsFromSettingsBundle()
        
        // navigationBarAppearace.tintColor = UIColor(named: "myOrange")
        //navigationBarAppearace.barTintColor = uicolorFromHex(0x034517)

        // change navigation item title color
        //navigationBarAppearace.titleTextAttributes =[NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        print("* * *", UserDefaultsHelper.appFilter)
        print("* * *", UserDefaultsHelper.appMultipleFilter)
        print("* * *", UserDefaultsHelper.appKioskFilter)
//        print("* * *", UserDefaultsHelper.teacherSelected)

        FirebaseApp.configure()
        return true
    }
    
    func registerDefaultsFromSettingsBundle()
    {
        let settingsUrl = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!.appendingPathComponent("Root.plist")
        let settingsPlist = NSDictionary(contentsOf:settingsUrl)!
        let preferences = settingsPlist["PreferenceSpecifiers"] as! [NSDictionary]

        var defaultsToRegister = Dictionary<String, Any>()

        for preference in preferences {
            guard let key = preference["Key"] as? String else {
                NSLog("Key not found")
                continue
            }
            print(preference["Key"], "->" , preference["DefaultValue"])
            defaultsToRegister[key] = preference["DefaultValue"]
        }
        UserDefaults.standard.register(defaults: defaultsToRegister)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//extension UIApplication {
//
//    static func topViewController(base: UIViewController? = UIApplication.sharedApplication().delegate?.window??.rootViewController) -> UIViewController? {
//        if let nav = base as? UINavigationController {
//            return topViewController(nav.visibleViewController)
//        }
//        if let tab = base as? UITabBarController, selected = tab.selectedViewController {
//            return topViewController(selected)
//        }
//        if let presented = base?.presentedViewController {
//            return topViewController(presented)
//        }
//
//        return base
//    }
//}

extension UIApplication {

    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}

