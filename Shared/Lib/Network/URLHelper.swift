//
//  URLHelper.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 11/04/2023.
//

import Foundation
import Combine

class URLHelper {
    
    public func requestUrl(scheme:HTTPScheme = HTTPScheme.https, host:String, path:String? = nil, queryParams:[URLQueryItem]? = nil) -> AnyPublisher<URLRequest,Error> {
        
        return Future() { promise in
            
            var components = URLComponents()
            components.scheme = scheme.rawValue
            components.host = host
            
            if let path = path {
                components.path = path
            }
            
            if let queryParams = queryParams  {
                components.queryItems = queryParams
            }
            
            guard let url = components.url else {
                return promise(.failure(NetworkServiceError.badUrl))
            }
            
            let urlRequest = URLRequest(url: url)
            
            return promise(.success(urlRequest))
            
        }.eraseToAnyPublisher()
        
    }
    
}
