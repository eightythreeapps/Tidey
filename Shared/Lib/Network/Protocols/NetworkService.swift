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
    func fetchData<T:Decodable>(request:URLRequest, responseModel: T.Type) -> AnyPublisher<T,Error>
}

extension Service {
    
    func fetchData<T:Decodable>(request:URLRequest, responseModel: T.Type) -> AnyPublisher<T,Error> {
        
        session.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw NetworkServiceError.badUrl
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return element.data
                case 500:
                    throw NetworkServiceError.serverError
                case 401:
                    throw NetworkServiceError.unauthorised
                case 403:
                    throw NetworkServiceError.forbidden
                case 404:
                    throw NetworkServiceError.notFound
                case 429:
                    throw NetworkServiceError.tooManyRequests
                default:
                    throw NetworkServiceError.unknownError
                }
                
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}

