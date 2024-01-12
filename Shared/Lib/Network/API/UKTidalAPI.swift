//
//  UKTidalAPIService.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import Foundation
import GeoJSON
import Combine
import Alamofire

public class DataParser {
    
    func parseFeatures(collection:FeatureCollection?) -> TideStations {
       
        if let features = collection?.features {
            var stations = TideStations()
            for feature in features {
                let tideStation = TideStation(feature: feature)
                stations.append(tideStation)
            }
            
            return stations
        }
        
        return TideStations()
        
    }
    
    func parseFeature(feature:Feature) -> TideStation {
        return TideStation(feature: feature)
    }
    
    func parseEvents(events:[Event]) -> TidalEvents {
        
        var tidalEvents = TidalEvents()
        
        for event in events {
            let tidalEvent = TidalEvent(event: event)
            tidalEvents.append(tidalEvent)
        }
        
        return tidalEvents
    }
    
}

public class TideDataAPI: Service {
    
    var defaultHeaders: HTTPHeaders
    var host: String
    var dataParser: DataParser
    
    required init(host:String, dataParser:DataParser, apiKey:String) {
        self.host = host
        self.dataParser = dataParser
//        self.host = Bundle.main.object(key: .tidalApiBaseUrl)
            
        self.defaultHeaders = [
            "Ocp-Apim-Subscription-Key":apiKey
        ]

    }
        
    func getStations() async throws -> TideStations {
        
        do {
            let response = try await self.fetchData(endpoint:"/uktidalapi/api/V1/Stations", responseModel: FeatureCollection.self)
            return self.dataParser.parseFeatures(collection: response)
        } catch(let error) {
            throw error
        }
        
    }
    
    func getStation(stationId:String) async throws -> TideStation {
    
        do {
            let response = try await self.fetchData(endpoint:"/uktidalapi/api/V1/Stations\(stationId)", responseModel: Feature.self)
            return self.dataParser.parseFeature(feature: response)
        } catch(let error) {
            throw error
        }

    }
    
    func getTidalEvents(stationId:String) async throws -> TidalEvents  {
        
        do {
            let response = try await self.fetchData(endpoint:"/uktidalapi/api/V1/Stations/\(stationId)/TidalEvents", responseModel: [Event].self)
            return self.dataParser.parseEvents(events: response)
        } catch(let error) {
            throw error
        }
            
    }
}


