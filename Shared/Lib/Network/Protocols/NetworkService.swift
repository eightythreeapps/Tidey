//
//  NetworkService.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 11/04/2023.
//

import Foundation
import Combine
import Alamofire

protocol Service {
    var host:String { get set }
    var defaultHeaders: HTTPHeaders { get set }
    func fetchData<T:Decodable>(endpoint:String, responseModel: T.Type) async throws -> T
}

extension Service {
    
    func fetchData<T:Decodable>(endpoint:String, responseModel: T.Type) async throws -> T {
        
        // Automatic String to URL conversion, Swift concurrency support, and automatic retry.
        let response = await AF.request("https://\(host)/\(endpoint)", headers: defaultHeaders)
                               .cacheResponse(using: .cache)
                               .validate()
                               .cURLDescription { description in
                                   print(description)
                               }
                               .serializingDecodable(responseModel)
                               .response
        
        switch response.result {
        case .success(let decodable):
            //TODO: Revisit this. Is forcing unrwapping ok given that AF is handling the parseing and *should* trigger the
            //.failure anyway?
            return response.value!
        case .failure(let error):
            print(error.localizedDescription)
            //TODO: Make error handling useful.
            throw NetworkServiceError.unknownError
        }
        
    }
    
}
