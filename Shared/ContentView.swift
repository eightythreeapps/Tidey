//
//  ContentView.swift
//  Tidey Watch Watch App
//
//  Created by Ben Reed on 14/04/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseRemoteConfig

struct ContentView: View {

    @ObservedObject var configurationProvider:ConfigurationProvider = ConfigurationProvider.shared
    
    let persistenceController = PersistenceController.shared
    var viewModelFactory:ViewModelFactory = ViewModelFactory(configuration: ConfigurationProvider.shared)
    
    init() {
        self.configurationProvider.fetchConfig()
    }
    
    var body: some View {
        
        switch configurationProvider.state {
        case .notLoaded:
            Text("Welcome")
        case .loading:
            ProgressView()
        case .loaded:
            
            NavigationSplitView {
                TideStationListView()
            } detail: {
                EmptyView()
            }
            .environmentObject(viewModelFactory.makeTideStationListViewModel())

        case .error:
            Text("There was an error loading the config")
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().makeContentView()
    }
}
