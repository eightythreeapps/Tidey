//
//  MockTideDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 12/01/2024.
//

import Foundation
import GeoJSON

class MockTideDataProvider:TideDataProvider {
    
    private var dataParser = TideDataGeoJSONParser()
    private var decoder = JSONDecoder()
    
    func getStations() async throws -> TideStations {
        let data = FileHelper.loadLocalJSON(fileType: .tideStations)
        let collection = try! decoder.decode(FeatureCollection.self, from: data)
        return dataParser.parseFeatures(collection: collection)
    }
    
    func getStation(stationId: String) async throws -> TideStation {
        let data = FileHelper.loadLocalJSON(fileType: .tideStations)
        let collection = try! decoder.decode(FeatureCollection.self, from: data)
        let stations = dataParser.parseFeatures(collection: collection)
        return stations.first!
    }
    
    func getTidalEvents(stationId: String) async throws -> TidalEvents {
        let data = FileHelper.loadLocalJSON(fileType: .tidalEvents)
        let events = try decoder.decode([Event].self, from: data)
        return dataParser.parseEvents(events: events)
    }

}
