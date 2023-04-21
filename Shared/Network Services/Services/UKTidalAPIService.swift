//
//  UKTidalAPIService.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import Foundation
import GeoJSON

protocol TideDataLoadable {
    func getStations() async throws -> [TideStation]
    func getStation(stationId:String) async throws -> TideStation
    func getTidalEvents(stationId:String) async throws -> TidalEvents
}

public class UKTidalAPI:TideDataLoadable, Service {
    var session: URLSession
    var baseUrl: String
    var urlHelper: URLHelper
    
    required init(session: URLSession, baseURL baseUrl: String, urlHelper: URLHelper) {
        self.session = session
        self.baseUrl = baseUrl
        self.urlHelper = urlHelper
    }
    
    static func newInstance(apiKey:String) -> TideDataLoadable {
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":apiKey]
            
        let session = URLSession(configuration: config)
        let baseURL = Bundle.main.object(key: .ukTidalApiBaseUrl)
        
        let tideAPIService = UKTidalAPI(session: session, baseURL: baseURL, urlHelper: URLHelper())
        
        return tideAPIService
    }
    
    func getStations() async throws -> [TideStation] {
        
        let result = await self.fetchData(method: .get, path: "/uktidalapi/api/V1/Stations", responseModel: FeatureCollection.self)

        switch result {
        case .success(let response):
            
            let features = response.features
            var stations = TideStations()
            for feature in features {
                let tideStation = TideStation(feature: feature)
                stations.append(tideStation)
            }
            return stations
            
        case .failure(let error):
            
            throw error
        }
        
    }
    
    func getStation(stationId:String) async throws -> TideStation {
        
        let result = await self.fetchData(method: .get, path: "/uktidalapi/api/V1/Stations/\(stationId)", responseModel: Feature.self)
                
        switch result {
        case .success(let response):
            let tideStation = TideStation(feature: response)
            return tideStation
        case .failure(let error):
            throw error
        }
        
    }
    
    func getTidalEvents(stationId:String) async throws -> TidalEvents {
        
        let result = await self.fetchData(method: .get, path: "/uktidalapi/api/V1/Stations/\(stationId)/TidalEvents", responseModel: [Event].self)
                
        switch result {
        case .success(let response):
            
            var tidalEvents = TidalEvents()
            
            for event in response {
                let tidalEvent = TidalEvent(event: event)
                tidalEvents.append(tidalEvent)
            }
            
            return tidalEvents
        case .failure(let error):
            throw error
        }
        
    }
}
