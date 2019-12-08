//
//  HelperFunctions.swift
//  Get a string from another string
//
//  Created by Steven Hertz on 11/17/19.
//  Copyright © 2019 DevelopItSolutions. All rights reserved.
//

import Foundation


enum GetStringFromError: Error {
    case delimeterNotFound
    case notEnoughProfiles
}
struct HelperFunctions {
    
    static func logIt(functionName: String, message: String) {
        print("* _ * _ * _", functionName, ":  \(message)")
    }
    
    static func getStringFrom(passedString: String, using delimiter: String = "~#~") throws -> (extractedString: String, cleanString: String) {
        
        guard let startIdx = passedString.range( of: delimiter,
                                            options: NSString.CompareOptions.literal,
                                            range: passedString.startIndex..<passedString.endIndex,
                                            locale: nil)?.upperBound
                                                    else {
                                                        print("error on start index")
                                                        throw GetStringFromError.delimeterNotFound}
        
        guard let endIdx = passedString.range( of: delimiter,
                                            options: NSString.CompareOptions.literal,
                                            range: startIdx..<passedString.endIndex,
                                            locale: nil)?.lowerBound
                                                  else { print("error on end index")
                                                    throw GetStringFromError.delimeterNotFound}

        
        let returnedSubstr = passedString[startIdx..<endIdx]
        
        let testingNumberOccurs = String(returnedSubstr).components(separatedBy:";")
        guard  testingNumberOccurs.count == 5 else {print("on number of occurences")
                                                    throw GetStringFromError.notEnoughProfiles}
        
        
        let cleanStr = passedString.replacingOccurrences(of: delimiter + returnedSubstr + delimiter, with: "")
         
        return ( String(returnedSubstr), String(cleanStr) )

    }
    
}




