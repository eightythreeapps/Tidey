//
//  MockTideData.swift
//  Tidey
//
//  Created by Ben Reed on 21/04/2023.
//

import Foundation
import GeoJSON

public class MockTideDataService:TideDataLoadable {
    
    private func getFeatures() -> FeatureCollection? {
        
        if let tideTimeJSON = Bundle.main.path(forResource: "UKTideStations", ofType: "json"){
            
            let data = try! Data(contentsOf: URL(fileURLWithPath: tideTimeJSON), options: .mappedIfSafe)
            let decodedResponse = try! JSONDecoder().decode(FeatureCollection.self, from: data)
            return decodedResponse
        }
        
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
        return stations.first!
        
    }
    
    func getTidalEvents(stationId: String) async throws -> TidalEvents {
        
        return [
            TidalEvent(event: Event(eventType: "HighWater",
                                    dateTime: "2023-04-21T04:05:00",
                                    isApproximateTime: true,
                                    height: 10.0,
                                    isApproximateHeight: true,
                                    filtered: false,
                                    date: "2023-04-21T00:00:00"))]
    }
    
    
}
