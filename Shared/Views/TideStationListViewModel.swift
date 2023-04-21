//
//  TideStationListViewModel.swift
//  Tidey
//
//  Created by Ben Reed on 21/04/2023.
//

import Foundation

class TideStationListViewModel:ObservableObject {
    
    private var tideStationAPIService:TideDataLoadable
    
    @Published var stations:[TideStation] = [TideStation]()
    @Published var viewState:ViewState = .notLoading
    @Published var path:[TideStation] = [TideStation]()
    @Published var tidalEvents:[TidalEvent] = [TidalEvent]()
    
    init(tideStationAPIService: TideDataLoadable) {
        self.tideStationAPIService = tideStationAPIService
    }
    
    func setViewState(viewState:ViewState) {
        self.viewState = viewState
    }
    
    func loadData() async {
        
        self.setViewState(viewState: .loading)
        
        do {
            self.stations = try await tideStationAPIService.getStations()
            self.viewState = .loaded
        } catch {
            self.setViewState(viewState: .error)
        }
    }
    
    func getEventsForStation(stationId:String) async {
        
        self.setViewState(viewState: .loading)
        
        do {
            let events = try await tideStationAPIService.getTidalEvents(stationId: stationId)
            self.tidalEvents = events
        } catch {
            self.setViewState(viewState: .error)
        }
    }
        
}
