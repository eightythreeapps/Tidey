//
//  PreviewDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 19/09/2023.
//

import Foundation
import GeoJSON
import Combine
import CoreLocation

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
    
    func getAllStations() -> AnyPublisher<TideStations, Error> {
        
        return apiClient.getStations()
            .map { _ in
             return TideStations()
            }
            .eraseToAnyPublisher()
        
    }
    
    func getStation(by id: String) -> AnyPublisher<TideStation, Error> {
        return apiClient.getStations()
            .map { _ in
                return TideStation(feature: Feature(geometry: nil))
            }
            .eraseToAnyPublisher()
    }
    
    func getTideEvents(for stationId: String) -> AnyPublisher<TidalEvents, Error> {
        return apiClient.getStations()
            .map { _ in
                return TidalEvents()
            }
            .eraseToAnyPublisher()
    }
    
    func getTideStation(for location: CLLocation) -> AnyPublisher<TideStation?, Error> {
        return apiClient.getStation(stationId: "")
            .map { _ in return nil }
            .eraseToAnyPublisher()
    }
    
    
}

class PreviewTideDataProvider:TideDataProvider {
    
    var apiClient: TideDataAPI
    var stations: TideStations?
    
    required init(apiClient: TideDataAPI) {
        //Won't be used in Preview. Each fucntion is mocked individually.
        self.apiClient = apiClient
    }
    
    func getAllStations() -> AnyPublisher<TideStations, Error> {
        let apiClient = MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStations.self)
        
        return apiClient.getStations()
            .eraseToAnyPublisher()
    }
    
    func getStation(by id: String) -> AnyPublisher<TideStation, Error> {
        let apiClient = MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStations.self)
        
        return apiClient.getStations()
            .map { $0.first(where: {$0.getStationId() == id})! }
            .eraseToAnyPublisher()
        
    }
    
    func getTideEvents(for stationId: String) -> AnyPublisher<TidalEvents, Error> {
        let apiClient = MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStationEvents.self)
        
        return apiClient.getTidalEvents(stationId: stationId)
            .eraseToAnyPublisher()
        
    }
    
    func getTideStation(for location:CLLocation) -> AnyPublisher<TideStation?, Error> {
        let apiClient = MockDataProvider.mockTideAPI(ofType: MockSuccessForTideStationEvents.self)
        
        return apiClient.getStations()
            .map {
                $0.getNearestStation(to: location)
            }
            .replaceEmpty(with: nil)
            .eraseToAnyPublisher()
    }
    
    
}
