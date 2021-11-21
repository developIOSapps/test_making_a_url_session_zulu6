//
//  ClassesReturnObjct.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/21/21.
//  Copyright © 2021 DIA. All rights reserved.
//

import Foundation

struct ClassesReturnObjct: Codable {
    let code: Int
    struct Classe: Codable {
        let uuid: String
        let name: String
        let description: String
        let locationId: Int
        let source: String
        let image: String
        let classAsmIdentifier: String
        let userGroupId: Int
        let studentCount: Int
        let teacherCount: Int
        let deviceGroupId: Int?
        let deviceCount: Int
        struct PasscodeLockGracePeriod: Codable {
            let hours: Int
            let minutes: Int
            let raw: Int
        }
        let passcodeLockGracePeriod: PasscodeLockGracePeriod
    }
    let classes: [Classe]
}

