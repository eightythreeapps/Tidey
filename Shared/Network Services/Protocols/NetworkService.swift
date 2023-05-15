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
    func fetchData<T:Decodable>(request:URLRequest, responseModel: T.Type) async throws -> T
}

extension Service {
    
    func fetchData<T:Decodable>(request:URLRequest, responseModel: T.Type) async throws -> T {
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.noResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
                return decodedResponse
            } catch {
                throw NetworkServiceError.parsingError
            }
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
    
}

