//
//  TideDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 21/09/2023.
//

import Foundation
import Combine
import CoreLocation

protocol TideDataProvider {
    
    var apiClient:TideDataAPI { get set }
    var stations:TideStations? { get set }
    
    init(apiClient:TideDataAPI)
    func getAllStations() -> AnyPublisher<TideStations, Error>
    func getStation(by id:String) -> AnyPublisher<TideStation, Error>
    func getTideEvents(for stationId:String) -> AnyPublisher<TidalEvents, Error>
    func getTideStation(for location:CLLocation) -> AnyPublisher<TideStation?, Error>
    
}
