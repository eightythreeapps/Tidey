//
//  URLHelper.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 11/04/2023.
//

import Foundation

class URLHelper {
    
    public func requestUrl(scheme:HTTPScheme = HTTPScheme.https, host:String, path:String? = nil, queryParams:[URLQueryItem]? = nil) -> URL? {
        
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        
        if let path = path {
            components.path = path
        }
        
        if let queryParams = queryParams  {
            components.queryItems = queryParams
        }
                
        return components.url
    }
    
}
