//
//  TideyApp.swift
//  Tidey
//
//  Created by Ben Reed on 14/04/2023.
//

import SwiftUI
import Combine
import CoreLocation

class ApplicationModel:ObservableObject {
    
    var configurationProvider:ConfigurationProvider
    var configCancellable = Set<AnyCancellable>()
    
    @Published var state:ApplicationState = .notConfigured
    
    init(configurationProvider:ConfigurationProvider) {
        self.configurationProvider = configurationProvider
        
        self.configurationProvider.fetchConfig()
            .flatMap { state in
                return self.configurationProvider.configValue(forKey: .tidalApiSubscriptionKey)
            }
            .sink { completion in
                print("Fetch config completed: \(completion)")
            } receiveValue: { apiKey in
                self.state = .configured(apiKey: apiKey)
            }
            .store(in: &configCancellable)
    }
}

@main
struct TideyApp: App {
    
    @State var applicationModel:ApplicationModel = ApplicationModel(configurationProvider: ConfigurationProvider(configurationSource: LocalConfiguration()))
    
    var body: some Scene {
        WindowGroup {
            
            switch applicationModel.state {
            case .notConfigured:
                Text("Setting things up for you")
            case .configured(let apiKey):
                NearMeView()
                    .environmentObject(NearMeViewModel(
                        tideStationDataProvider: TideStationDataProvider(apiClient: TideDataAPI(apiKey: apiKey)),
                        locationService: LocationService(locationManager: CLLocationManager())))
            case .loadingConfig:
                Text("Setting things up for you")
            case .configLoaded:
                Text("Config loaded")
            }
            
        }
    }
}



