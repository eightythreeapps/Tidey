//
//  TideDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 11/01/2024.
//

import Foundation

protocol TideDataProvider {
    func getStations() async throws -> TideStations
    func getStation(stationId:String) async throws -> TideStation
    func getTidalEvents(stationId:String) async throws -> TidalEvents
}
