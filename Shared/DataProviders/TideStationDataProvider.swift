//
//  TideStationDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 21/09/2023.
//

import Foundation
import Combine
import CoreLocation

class TideStationDataProvider:TideDataProvider {
    
    var stations: TideStations?
    var apiClient: TideDataAPI
    
    required init(apiClient: TideDataAPI) {
        self.apiClient = apiClient
    }
    
    func getAllStations() -> AnyPublisher<TideStations, Error> {
    
        apiClient.getStations()
            .eraseToAnyPublisher()
    
    }
    
    func getStation(by id: String) -> AnyPublisher<TideStation, Error> {
        apiClient.getStation(stationId: id)
            .eraseToAnyPublisher()
    }
    
    func getTideEvents(for stationId: String) -> AnyPublisher<TidalEvents, Error> {
        apiClient.getTidalEvents(stationId: stationId)
            .eraseToAnyPublisher()
    }
    
    func getTideStation(for location:CLLocation) -> AnyPublisher<TideStation?, Error> {
        
        apiClient.getStations()
            .map { 
                $0.getNearestStation(to: location)
            }
            .replaceEmpty(with: nil)
            .eraseToAnyPublisher()
                
    }
    
    
}
