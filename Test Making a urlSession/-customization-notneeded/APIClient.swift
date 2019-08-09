//
//  APIClient.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 5/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation

class WeatherAPIClient {
    
    private var BASE_URL: String { return Config.shared.BASE_URL}
    
    private var API_KEY: String { return Config.shared.API_KEY}


    
    private func getURLRequest(withQuery query: QueryType) -> URLRequest? {
        
        if var urlComponents = URLComponents(string: BASE_URL) {
            
            urlComponents.query = "\(query.path)&APPID=\(API_KEY)"
            
            guard let url = urlComponents.url else { return nil }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = query.httpMethod.rawValue
            
            request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            
            return request
            
        }
        
        return nil
        
    }
    
}

