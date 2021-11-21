//
//  UserResponse.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 6/6/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation


struct UserInfoReturnObjct: Codable {
    let code: Int
    struct User: Codable {
        let id: Int
        let locationId: Int
        let status: String
        let deviceCount: Int
        let email: String
        let username: String
        let domain: String
        let firstName: String
        let lastName: String
        let name: String
        let groupIds: [Int]
        let groups: [String]
        let teacherGroups: [Int]
        let notes: String
        let exclude: Bool
        let modified: String
    }
    let user: User
}

