//
//  UserDefaultsHelper.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 12/5/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation


struct UserDefaultsHelper {
    
    /// convinience
    static let defaults = UserDefaults.standard
    
    /// literals
    static let groupIDKey = "teacherSelected"
    static let groupNameKey = "groupNameKey"

    static let applicationProfilesKey = "applicationProfiles"
    static let applicationProfilesMultipleKey = "applicationProfilesMultiple"
    static let applicationProfilesSingleKey = "applicationProfilesSingle"
    static let applicationProfilesKioskKey = "applicationProfilesKiosk"

    // static let teacherSelectedKey = "teacherSelected"

    
    /// computedProperty
    static var groupID: Int? {
        return getGroupID() != 0 ? getGroupID() : nil
    }
    static var groupName: String? {
        guard let groupID = groupID, groupID != 0 else { return nil }
        return teacherNames[groupID]
    }
    static var appFilter: String  {
        return getAppFilterString()
    }
    static var appMultipleFilter: String  {
        return getAppMultipleFilterString()
    }
    static var appKioskFilter: String  {
        return getAppKioskFilterString()
    }
    static var app1KioskFilter: String  {
        return getApp1KioskFilterString()
    }

    static var teacherNames: [Int:String] = [
        17: "Morah Ilana" ,  18: "Morah Chaya" ,  19: "Morah Chumie" ,  20: "Morah Shaindy" ,  21: "Morah Gitty" , 22: "Morah Chaya Raizy"
    ]
    
    
//    static var teacherSelected: Int?  {
//        return getteacherSelected()
//    }


    /// samething with closure
    static var groupID2: Int? = {
        return getGroupID() != 0 ? getGroupID() : nil
    }()

    
    static func getGroupID() -> Int {
        HelperFunctions.logIt(functionName: #function, message: "Get The GroupId")
        return defaults.integer(forKey: groupIDKey)
    }
    
    static func setGroupID(_ groupID: Int) {
        HelperFunctions.logIt(functionName: #function, message: "Saving The GroupId")
        defaults.set(groupID, forKey: groupIDKey)
    }

    static func removeGroupID() {
        defaults.removeObject(forKey: groupIDKey)
    }
    
    static func getGroupName() -> String? {
        HelperFunctions.logIt(functionName: #function, message: "Get The GroupName")
        return defaults.object(forKey: groupNameKey) as? String
    }
    
    static func setGroupName(_ groupName: String) {
        HelperFunctions.logIt(functionName: #function, message: "Saving The GroupName")
        defaults.set(groupName, forKey: groupNameKey)
    }

    static func removeGroupName() {
        defaults.removeObject(forKey: groupNameKey)
    }
    
    
    
    static func getAppFilterString() -> String {
        HelperFunctions.logIt(functionName: #function, message: "Get App Filter String")
        return  defaults.object(forKey: applicationProfilesKey) as! String
    }
    
    static func getAppMultipleFilterString() -> String {
        HelperFunctions.logIt(functionName: #function, message: "Get App Category Filter String")
        return defaults.object(forKey: applicationProfilesMultipleKey) as! String
    }
    
    static func getAppKioskFilterString() -> String {
        HelperFunctions.logIt(functionName: #function, message: "Get App Kiosk Filter String")
        return defaults.object(forKey: applicationProfilesSingleKey) as! String
    }

    static func getApp1KioskFilterString() -> String {
        HelperFunctions.logIt(functionName: #function, message: "Get App 1Kiosk Filter String")
        return defaults.object(forKey: applicationProfilesKioskKey) as! String
    }


//    static func getteacherSelected() -> Int? {
//        HelperFunctions.logIt(functionName: #function, message: "Get Teacher Selected")
//        return defaults.object(forKey: teacherSelectedKey) as? Int
//    }
//
//    static func updateSelectedTeacher(groupID: Int) {
//        HelperFunctions.logIt(functionName: #function, message: "_____________Update Teacher Selected \(groupID)")
//        defaults.set(groupID, forKey: teacherSelectedKey)
//        return
//    }



}
