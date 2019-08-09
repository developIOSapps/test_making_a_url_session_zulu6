//
//  QueryType.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 5/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

protocol QueryType {
    
    var path: String { get }
    
    var httpMethod: HTTPMethod { get }
    
}

struct Query: QueryType {
    
    var path: String
    
    var httpMethod: HTTPMethod
    
}
