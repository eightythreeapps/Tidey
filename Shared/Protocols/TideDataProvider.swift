//
//  TideDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 21/09/2023.
//

import Foundation



protocol TideDataProvider {
    
    var apiClient:TideDataAPI { get set }
    var stations:TideStations? { get set }
    
    init(apiClient:TideDataAPI)
    func getAllStations() async throws -> TideStations
    func getStation(by id:String) async throws -> TideStation
    func getTideEvents(for stationId:String) async throws -> TidalEvents
    
}
