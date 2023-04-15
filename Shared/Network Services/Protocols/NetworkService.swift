//
//  NetworkService.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 11/04/2023.
//

import Foundation
import Combine

protocol Service {
    
    var session:URLSession { get set }
    var baseUrl:String { get set }
    var urlHelper:URLHelper { get set }
    
    init(session:URLSession, baseURL:String, urlHelper:URLHelper)
    func fetchData<T:Decodable>(method:HTTPMethod, path: String, queryParams:[URLQueryItem]?, responseModel: T.Type) async -> Result<T, NetworkServiceError>
}

extension Service {
    
    func fetchData<T:Decodable>(method:HTTPMethod, path: String, queryParams:[URLQueryItem]? = nil, responseModel: T.Type) async -> Result<T, NetworkServiceError> {
        
        guard let url = urlHelper.requestUrl(host: self.baseUrl, path: path, queryParams: queryParams) else {
            return .failure(.badUrl)
        }
        
        var request = URLRequest(url: url, timeoutInterval: 60.0)
        request.httpMethod = method.stringValue()
        
        do {
            
            let (data, httpResponse) = try await self.session.data(for: request)
            guard let response = httpResponse as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                
                do {
                    let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                    return .success(decodedResponse)
                } catch {
                    print(error)
                    return .failure(.parsingError)
                }
                
            case 401:
                return .failure(.unauthorised)
            default:
                return .failure(.httpError(code: response.statusCode))
            }
            
        } catch {
            return .failure(.unknownError(error: error))
        }
        
    }
    
}

