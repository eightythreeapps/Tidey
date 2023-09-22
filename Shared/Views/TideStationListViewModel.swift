//
//  TideStationListViewModel.swift
//  Tidey
//
//  Created by Ben Reed on 21/04/2023.
//

import Foundation
import MapKit
import CoreLocation
import GeoJSON

@MainActor
class TideStationListViewModel:ObservableObject {
    
    private var tideStationDataProvider:TideDataProvider
    
    @Published var stations:TideStations = [TideStation]()
    @Published var selectedStation:TideStation?
    @Published var viewState:LoadingState = .idle
    @Published var path:[TideStation] = [TideStation]()
    @Published var tidalEvents:[TidalEvent] = [TidalEvent]()
    @Published var stationName:String = ""
    
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    init(tideStationDataProvider:TideDataProvider) {
        self.tideStationDataProvider = tideStationDataProvider
    }
    
    func findStationClosestToLocation(location:CLLocation) async {
        
        self.viewState = .loading
        await self.loadData()
        self.selectedStation = self.stations.getNearestStation(to: location)
        self.stationName = selectedStation?.getStationName() ?? ""
        
        if let station = self.selectedStation, let stationId = station.getStationId() {
            await self.getDetailsForStation(stationId:stationId)
            self.viewState = .loaded
        }
        
    }
    
    func loadData() async {
        
        self.viewState = .loading
        
        do {
            self.stations = try await tideStationDataProvider.getAllStations()
            self.viewState = .loaded
        } catch {
            self.viewState = .error
        }
    }
    
    func getStation(stationId:String) -> TideStation {
        
        let defaultStation = TideStation(feature: Feature(geometry: nil))
        
        if let station = self.stations.first(where: { $0.getStationId() == stationId }) {
            return station
        }
            
        return defaultStation
        
    }

    func getDetailsForStation(stationId:String) async {
        
        do {
            self.tidalEvents = try await self.tideStationDataProvider.getTideEvents(for: stationId)
            self.viewState = .loaded
        } catch {
            self.viewState = .error
        }
        
    }
    
}
