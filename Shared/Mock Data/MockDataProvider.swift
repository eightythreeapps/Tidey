//
//  PreviewDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 19/09/2023.
//

import Foundation
import GeoJSON

enum PreviewFile:String {
    case tideStations = "UKTideStations"
    case station = "UKTideStation"
    case tidalEvents = "TideEvents"
    case tideStationsBad = "UKTideStationsBadData"
}

class MockDataProvider {
    
    class PreviewProvider {
        
        public static var TideDataProvider:TideDataProvider {
            return PreviewTideDataProvider(apiClient: MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStations.self))
        }
        
    }
    
    class TestProvider {
        public static var TideDataProviderEmpty:TideDataProvider {
            return MockEmptyTideDataProvider(apiClient: MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStations.self))
        }
    }
    
    public static func mockTideAPI(ofType type:AnyClass) -> TideDataAPI {
        
        URLProtocol.registerClass(type)
        let mockConfig = URLSessionConfiguration.ephemeral

        mockConfig.protocolClasses?.insert(type, at: 0)
        let session = URLSession(configuration: mockConfig)
        
        let tideAPIService = TideDataAPI(session: session, host: "", urlHelper: URLHelper())
        
        return tideAPIService
        
    }
    
    class FileHelper {
        
        static func loadLocalJSON(fileType:PreviewFile) -> Data {
            let stations = Bundle.main.path(forResource: fileType.rawValue, ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: stations), options: .mappedIfSafe)
            return data
        }
        
    }
    
}

class MockEmptyTideDataProvider:TideDataProvider {
    
    var apiClient: TideDataAPI
    var stations: TideStations?
    
    required init(apiClient: TideDataAPI) {
        self.apiClient = apiClient
    }
    
    func getAllStations() async -> TideStations {
        return TideStations()
    }
    
    func getStation(by id: String) async -> TideStation {
        return TideStation(feature: Feature(geometry: nil))
    }
    
    func getTideEvents(for stationId: String) async throws -> TidalEvents {
        return TidalEvents()
    }
    
    
}

class PreviewTideDataProvider:TideDataProvider {
    
    var apiClient: TideDataAPI
    var stations: TideStations?
    
    required init(apiClient: TideDataAPI) {
        //Won't be used in Preview. Each fucntion is mocked individually.
        self.apiClient = apiClient
    }
    
    func getAllStations() async throws -> TideStations {
        let apiClient = MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStations.self)
        let stations = try! await apiClient.getStations()
        return stations
    }
    
    func getStation(by id: String) async throws -> TideStation {
        let apiClient = MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStations.self)
        let stations = try! await apiClient.getStations()
        return stations.first(where: { $0.getStationId() == id })!
    }
    
    func getTideEvents(for stationId: String) async throws -> TidalEvents {
        let apiClient = MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStationEvents.self)
        return try! await apiClient.getTidalEvents(stationId: stationId)
    }
    
}
