//
//  UKTidalAPIService.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import Foundation
import GeoJSON
import Combine

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
    
    func getStations() -> AnyPublisher<TideStations, Error> {
    
        urlHelper.requestUrl(host: host, path: "/uktidalapi/api/V1/Stations")
            .map {
                self.fetchData(request: $0, responseModel: FeatureCollection.self)
            }
            .flatMap {
                Publishers.MergeMany(
                    $0.map {
                        let features = $0.features
                        var stations = TideStations()
                        for feature in features {
                            let tideStation = TideStation(feature: feature)
                            stations.append(tideStation)
                        }
                        return stations
                    }
                )
            }
            .mapError { error in
                return NetworkServiceError.parsingError
            }
            .eraseToAnyPublisher()
    }
    
    func getStation(stationId:String) -> AnyPublisher<TideStation, Error> {
    
        urlHelper.requestUrl(host: host, path: "/uktidalapi/api/V1/Stations/\(stationId)")
            .map {
                self.fetchData(request: $0, responseModel: Feature.self)
            }
            .flatMap {
                Publishers.MergeMany(
                    $0.map {
                        TideStation(feature: $0)
                    }
                )
            }
            .eraseToAnyPublisher()
    
    }
    
    func getTidalEvents(stationId:String) -> AnyPublisher<TidalEvents, Error> {
                 
        urlHelper.requestUrl(host: host, path: "/uktidalapi/api/V1/Stations/\(stationId)/TidalEvents")
            .map {
                self.fetchData(request: $0, responseModel: [Event].self)
            }
            .flatMap {
                Publishers.MergeMany(
                    
                    $0.map {
                        var tidalEvents = TidalEvents()
                        
                        for event in $0 {
                            let tidalEvent = TidalEvent(event: event)
                            tidalEvents.append(tidalEvent)
                        }
                        
                        return tidalEvents
                    }
                    
                )
            }
            .eraseToAnyPublisher()
        
    }
}


