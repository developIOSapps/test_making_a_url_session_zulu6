//
//  AppsResponse.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/6/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

//struct AppsResponse: Codable {
//    let results: [App]
//}
//
//struct App: Codable {
//    let name: String
//}

struct AppsResponse: Codable {
    struct App: Codable {
//        let icon: URL
//        let shortVersion: String
//        let isDeleted: Bool
//        let id: Int
//        let platform: String
//        let bundleId: String
//        let supportsiBooks: Bool
//        let showInTeacher: Bool
//        let version: Date
//        let isBook: Bool
//        let description: String
//        let type: String
//        //let automaticReinstallWhenRemoved: Any? //TODO: Specify the type to conforms Codable protocol
//        let mediaPriority: Int
//        let isDeviceAssignable: Bool
//        let extVersion: Int
//        let adamId: Int
//        let isCustomB2B: Bool
//        let removeWithProfile: Bool
//        let disableBackup: Bool
//        let allowTeacherDistribution: Bool
        let name: String
//        let externalVersion: Int
//        let html: String
//        let price: Int
//        let showInParent: Bool
//        let lastModified: String
//        let deviceFamilies: [String]
//        let locationId: Int
//        let is32BitOnly: Bool
//        let isTvOSCompatible: Bool
//        let vendor: String
//        //let teacherGroups: [Any] //TODO: Specify the type to conforms Codable protocol
//        let usedLicenses: Int?
//        let totalLicenses: Int?
//        let availableLicenses: Int?
//        let autoGrant: Bool?
//        let autoRevoke: Bool?
    }
    let results: [App]
}
