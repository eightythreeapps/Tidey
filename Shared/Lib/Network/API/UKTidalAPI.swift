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

public class TideDataAPI: Service, TideDataProvider, ObservableObject {
    
    var defaultHeaders: HTTPHeaders
    var host: String
    var dataParser: TideDataParser
    
    required init(host:String, dataParser:TideDataParser, apiKey:String) {
        self.host = host
        self.dataParser = dataParser
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


