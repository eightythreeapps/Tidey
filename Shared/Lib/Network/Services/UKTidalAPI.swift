//
//  UKTidalAPIService.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import Foundation
import GeoJSON

public class TideDataAPI: Service {
    
    var session: URLSession
    var host: String
    var urlHelper: URLHelper
    
    required init(session: URLSession, host: String, urlHelper: URLHelper) {
        self.session = session
        self.host = host
        self.urlHelper = urlHelper
    }
        
    convenience init(apiKey:String) {
     
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":apiKey]
            
        let session = URLSession(configuration: config)
        let host = Bundle.main.object(key: .tidalApiBaseUrl)
        
        self.init(session: session, host: host, urlHelper: URLHelper())
        
    }
    
    func getStations() async throws -> TideStations {
        
        do {
            
            let url = try urlHelper.requestUrl(host: host, path: "/uktidalapi/api/V1/Stations")
            let request = URLRequest(url: url!)
            
            let result = try await self.fetchData(request: request, responseModel: FeatureCollection.self)
            let features = result.features
            var stations = TideStations()
            for feature in features {
                let tideStation = TideStation(feature: feature)
                stations.append(tideStation)
            }
            return stations
        } catch {
            throw error
        }
    }
    
    func getStation(stationId:String) async throws -> TideStation {
        
        do {
            let url = try urlHelper.requestUrl(host: host, path: "/uktidalapi/api/V1/Stations/\(stationId)")
            let request = URLRequest(url: url!)
            
            let result = try await self.fetchData(request: request, responseModel: Feature.self)
            let tideStation = TideStation(feature: result)
            return tideStation
        } catch {
            throw error
        }
    
    }
    
    func getTidalEvents(stationId:String) async throws -> TidalEvents {
                 
        do {
            
            let url = try urlHelper.requestUrl(host: host, path: "/uktidalapi/api/V1/Stations/\(stationId)/TidalEvents")
            let request = URLRequest(url: url!)
            let result = try await self.fetchData(request: request, responseModel: [Event].self)
            var tidalEvents = TidalEvents()
            
            for event in result {
                let tidalEvent = TidalEvent(event: event)
                tidalEvents.append(tidalEvent)
            }
            
            return tidalEvents
        } catch {
            throw error
        }
    }
}


