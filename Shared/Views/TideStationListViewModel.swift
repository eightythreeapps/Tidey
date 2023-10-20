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
import Combine

@MainActor
class NearMeViewModel:ObservableObject {
    
    private var tideStationDataProvider:TideDataProvider
    private var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    private var locationService:LocationService
    
    @Published var stations:TideStations = [TideStation]()
    @Published var path:[TideStation] = [TideStation]()
    @Published var tidalEvents:[TidalEvent] = [TidalEvent]()
    @Published var stationName:String = "Unknown"
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), 
                                                  span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published var locationState:LocationProviderState = .determiningAuthorisation
    @Published var userLocation:CLLocation? = nil
    @Published var selectedStation:TideStation?
    
    @Published var statusMessage = ""
   
    init(tideStationDataProvider:TideDataProvider, locationService:LocationService) {
        self.tideStationDataProvider = tideStationDataProvider
        self.locationService = locationService
        
        self.setupAuthStatusSubscriber()
        self.setUpLocationSubscriber()
        
    }
    
    func findStationClosestToUser() {
        self.locationService.requestAuthorization()
    }
    
    func setUpLocationSubscriber() {
        
        self.locationService.$currentLocation
            .flatMap { location in
                self.tideStationDataProvider.getTideStation(for: location)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { tideStation in
                self.selectedStation = tideStation
            }
            .store(in: &cancellables)
        
    }
    
    func setupAuthStatusSubscriber() {
        self.locationService.$authorisationState
            .sink { state in
                
                switch state {
                
                case .denied(status: _):
                    self.statusMessage = "Access to your location has not been authorized"
                case .authorised(status: _):
                    self.statusMessage = "Locating user"
                case .determiningAuthorisation:
                    self.statusMessage = "Figuring out location access"
                case .determiningUserLocation:
                    self.statusMessage = "Locating you"
                case .locationUpdated(location: _):
                    self.statusMessage = "Found you"
                case .error:
                    self.statusMessage = "Something is broken"
                }
                
            }
            .store(in: &cancellables)
    }
  
    
    func getStation(stationId:String) -> TideStation {
        
        let defaultStation = TideStation(feature: Feature(geometry: nil))
        
        if let station = self.stations.first(where: { $0.getStationId() == stationId }) {
            return station
        }
            
        return defaultStation
        
    }
    
    func getDetailsForStation(stationId:String) async {
        
        tideStationDataProvider.getTideEvents(for: stationId)
            .sink { completion in
                
            } receiveValue: { events in
                self.tidalEvents = events
            }
            .store(in: &cancellables)

        
    }
    
}
