//
//  TideyApp.swift
//  Tidey
//
//  Created by Ben Reed on 14/04/2023.
//

import SwiftUI
import CoreLocation

@main
struct TideyApp: App {
    
    @StateObject var configurationProvider = ConfigurationProvider(configurationSource: LocalConfiguration())
    
    var body: some Scene {
        WindowGroup {
            
            VStack {
                
                switch configurationProvider.state {
                case .configured(let config):
                    
                    RootView()
                        .environmentObject(ApplicationDataModel(config: config,
                                                                tideDataProvider: TideDataAPI(host: config.baseURL,
                                                                                              dataParser: TideDataGeoJSONParser(),
                                                                                              apiKey: config.apiKey)))
                case .loadingConfig:
                    
                    ProgressView {
                        Text("Loading config")
                    }
                    
                case .error(let configError):
                    Text(configError.localizedDescription)
                }
                
            }.task {
                await configurationProvider.fetchConfig()
            }
        }
    }
}



