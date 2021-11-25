//
//  ApiKey.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/21/21.
//  Copyright © 2021 DIA. All rights reserved.
//

import Foundation

enum MDMStatus {
    case missing
    case found
    case fromLoginVC
}


class SchoolInfo {
        
    var thekey: String
    var companyId: Int
    var udid: String?
    var asset: String?
    
    
//    CompanyId
//    udid
//    asset
//    api
//
    var mngedCfgitems = ""

    
    static func getApiKey() -> String? {
        "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU="
    }
    
    static func getCompanyCode() -> Int {
        1049131
    }
    
    init?() {
        
        mngedCfgitems += "About to get the managed config file \n"
        
        let managedConfigFileKey = "com.apple.configuration.managed"

        guard let managedConfigObj = UserDefaults.standard.object(forKey: managedConfigFileKey ) else {
            mngedCfgitems += "Could not find the managed config file \n"
            return nil
        }

        guard let managedConfigDict = managedConfigObj as?  [String:Any?]  else {
            mngedCfgitems += "Failed converting it to dictionarye \n"
            return nil
        }

        // get api key
        guard let theapi  = managedConfigDict["api"] as?  String  else {
            mngedCfgitems += "Failed getting api \n"
            return nil
        }
        thekey = theapi
        mngedCfgitems += "Getting api directly \(theapi)  \n"

        // get company code
        guard let companyCD  = managedConfigDict["CompanyId"] as?  Int  else {
            mngedCfgitems += "Failed getting CompanyId \n"
            return nil
        }
        companyId = companyCD
        mngedCfgitems += "Getting companyId directly \(companyCD)  \n"

        // get udidmng
        guard let udidmng  = managedConfigDict["udid"] as?  String  else {
            mngedCfgitems += "Failed getting udid \n"
            return
        }
        udid = udidmng
        mngedCfgitems += "Getting udid directly \(udidmng)  \n"


        // get asset
        guard let assetmng  = managedConfigDict["asset"] as?  String  else {
            mngedCfgitems += "Failed getting asset \n"
            return
        }
        asset = assetmng
        mngedCfgitems += "Getting asset directly \(assetmng)  \n"


        for (key, value) in managedConfigDict {
            mngedCfgitems += "key is: \(key) and value is \(String(describing: value!)) \n"
        }
        
    }
    init(apiKey: String, CompanyID: Int) {
        self.thekey = apiKey
        self.companyId = CompanyID
    }

    
//
//    init?(input : Int) {
//
//        if input == 0 {
//            return nil
//        }
//
//        // get api key
//        thekey = "Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU="
//
//        // get company code
//        companyId = 1049131
//
//    }
  
}


