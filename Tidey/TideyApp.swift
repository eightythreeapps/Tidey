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
                    RootView(config: config)
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



