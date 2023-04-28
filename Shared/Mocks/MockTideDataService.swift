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
    
    private func getStations(from collection:FeatureCollection) -> [TideStation] {
        var stations = TideStations()
        
        if let features = self.getFeatures()?.features {
            for feature in features {
                let tideStation = TideStation(feature: feature)
                stations.append(tideStation)
            }
        }
        
        return stations
    }
    
    func getStations() async throws -> [TideStation] {
        
        let stations = getStations(from: getFeatures()!)
        return stations
        
    }
    
    func getStation(stationId: String) async throws -> TideStation {
        
        let stations = getStations(from: getFeatures()!)
        
        if let station = stations.first(where: { $0.getStationId() == stationId }) {
            return station
        } else {
            throw NetworkServiceError.notFound
        }
        
    }
    
    func getTidalEvents(stationId: String) async throws -> TidalEvents {
      
        guard let tideEvents = BundleFactory.bundleFor(classType: self).path(forResource: "TideEvents", ofType: "json") else {
            throw NetworkServiceError.parsingError
        }

        let data = try! Data(contentsOf: URL(fileURLWithPath: tideEvents), options: .mappedIfSafe)
        let decodedResponse = try! JSONDecoder().decode(TidalEvents.self, from: data)
        return decodedResponse
        
    }
    
}
