//
//  TideStationDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 21/09/2023.
//

import Foundation

class TideStationDataProvider:TideDataProvider {
    
    var stations: TideStations?
    var apiClient: TideDataAPI
    
    required init(apiClient: TideDataAPI) {
        self.apiClient = apiClient
    }

    func getAllStations() async throws -> TideStations {

        if let loadedStations = self.stations {
            return loadedStations
        }
        
        do {
            let stations = try await self.apiClient.getStations()
            self.stations = stations
            return stations
        } catch {
            throw error
        }
        
    }
    
    func getStation(by id: String) throws -> TideStation {
        
        if let loadedStations = self.stations {
            if let station = loadedStations.first(where: { $0.getStationId() == id }) {
                return station
            }else{
                throw NetworkServiceError.notFound
            }
        }else{
            //TODO: Replace with Data Provider level error
            throw NetworkServiceError.notFound
        }
        
        
    }
    
    func getTideEvents(for stationId: String) async throws -> TidalEvents {
        
        do {
            return try await apiClient.getTidalEvents(stationId: stationId)
        } catch {
            throw error
        }
        
    }
    
}
