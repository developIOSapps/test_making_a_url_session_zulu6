//
//  ApiKey.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/21/21.
//  Copyright © 2021 DIA. All rights reserved.
//

import Foundation

struct SchoolInfo {
    let thekey: String
    let companyId: Int

    static func getApiKey() -> String? {
         "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU="
    }
    
    static func getCompanyCode() -> Int {
         1049131
    }
}

