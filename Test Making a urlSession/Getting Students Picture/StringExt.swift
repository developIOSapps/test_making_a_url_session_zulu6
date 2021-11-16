//
//  StringExt.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/15/21.
//  Copyright © 2021 DIA. All rights reserved.
//

import Foundation

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}


/* Sample to demonstrate this
let yourString = #"abd<\def\>ghi"#
let slicedString = yourString.slice(from: "<\\", to: "\\>")
let x = "appi4<q1234>appi4"
let slicedString2 = x.slice(from: "appi4<", to: ">appi4")
*/
