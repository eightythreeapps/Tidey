//
//  TideStationListViewModel.swift
//  Tidey
//
//  Created by Ben Reed on 21/04/2023.
//

import Foundation
import CoreLocation

@MainActor
class TideStationListViewModel:ObservableObject {
    
    private var tideStationAPIService:TideDataLoadable
    
    @Published var stations:TideStations = [TideStation]()
    @Published var viewState:LoadingState = .notLoading
    @Published var path:[TideStation] = [TideStation]()
    @Published var tidalEvents:[TidalEvent] = [TidalEvent]()
    @Published var selectedStation:TideStation?
    @Published var stationName:String = ""
    
    init(tideStationAPIService: TideDataLoadable) {
        self.tideStationAPIService = tideStationAPIService
    }
    
    func setViewState(viewState:LoadingState) {
        self.viewState = viewState
    }
    
    func findStationClosestToLocation(location:CLLocation) async {
        
        self.viewState = .loading
        await self.loadData()
        self.selectedStation = self.stations.getNearestStation(to: location)
        self.stationName = selectedStation?.getStationName() ?? ""
        
        if let station = self.selectedStation, let stationId = station.getStationId() {
            await self.getEventsForStation(stationId:stationId)
            self.setViewState(viewState: .loaded)
        }
        
    }
    
    func loadData() async {
        
        self.viewState = .loading
        
        do {
            self.stations = try await tideStationAPIService.getStations()
            self.viewState = .loaded
        } catch {
            self.setViewState(viewState: .error)
        }
    }

    func getEventsForStation(stationId:String) async {
        
        self.viewState = .loading
        
        do {
            let events = try await tideStationAPIService.getTidalEvents(stationId: stationId)
            self.tidalEvents = events
            self.viewState = .loaded
        } catch {
            self.setViewState(viewState: .error)
        }
    }
        
}
