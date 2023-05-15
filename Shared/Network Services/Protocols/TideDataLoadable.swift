//
//  TideDataLoadable.swift
//  Tidey
//
//  Created by Ben Reed on 26/04/2023.
//

import Foundation

protocol TideDataLoadable {
    
    var session: URLSession { get set }
    var baseUrl: String { get set }
    var urlHelper: URLHelper { get set }
    
    init(session: URLSession, baseURL baseUrl: String, urlHelper: URLHelper)
    
    func getStations() async throws -> TideStations
    func getStation(stationId:String) async throws -> TideStation
    func getTidalEvents(stationId:String) async throws -> TidalEvents
}
