//
//  MockService.swift
//  Tidey
//
//  Created by Ben Reed on 14/04/2023.
//

import Foundation

public class MockService:Service {
    var session: URLSession
    var baseUrl: String
    var urlHelper: URLHelper
    
    required init(session: URLSession, baseURL: String, urlHelper: URLHelper) {
        self.session = session
        self.baseUrl = baseURL
        self.urlHelper = urlHelper
    }
    
    func fetchData<T>(method: HTTPMethod, path: String, queryParams: [URLQueryItem]?, responseModel: T.Type) async -> Result<T, NetworkServiceError> where T : Decodable {
        return .failure(.unauthorised)
    }
    
    
}
