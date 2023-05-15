//
//  MockTideData.swift
//  Tidey
//
//  Created by Ben Reed on 21/04/2023.
//

import Foundation
import GeoJSON

public class MockTideDataService:TideDataLoadable {
    var session: URLSession
    var baseUrl: String
    var urlHelper: URLHelper
    
    required init(session: URLSession, baseURL baseUrl: String, urlHelper: URLHelper) {
        self.session = session
        self.baseUrl = baseUrl
        self.urlHelper = urlHelper
    }
    
    private func getFeatures() -> FeatureCollection? {
        return nil
    }
    
    func getStations() async throws -> [TideStation] {
        throw NetworkServiceError.badUrl
    }
    
    func getStation(stationId: String) async throws -> TideStation {
        throw NetworkServiceError.badUrl
    }
    
    func getTidalEvents(stationId: String) async throws -> TidalEvents {
        throw NetworkServiceError.badUrl
    }
    
}
