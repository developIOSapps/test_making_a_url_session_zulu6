//
//  String xTensn.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 2/18/20.
//  Copyright © 2020 DIA. All rights reserved.
//

import Foundation

extension String {
    func removeFrom(chars delimiter: String) -> String {
        var modifiedString = self

        let delimeterRange = modifiedString.range(of: delimiter)
        if let delimeterRangeLB = delimeterRange?.lowerBound {
            modifiedString = String(modifiedString[..<delimeterRangeLB])
        }

        return modifiedString
    }
    func removeTo(chars delimiter: String) -> String? {
        
        let delimeterRange = self.range(of: delimiter)
        if let delimeterRangeUB = delimeterRange?.upperBound {
            let modifiedString = String(self[delimeterRangeUB...])
            return modifiedString
        }
        
        return nil
        
        
    }
}

/*
let x = "Hello_#You"
print(x.removeFrom(chars: "_#")) // Prints Hello
*/
