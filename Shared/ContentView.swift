//
//  ContentView.swift
//  Tidey Watch Watch App
//
//  Created by Ben Reed on 14/04/2023.
//

import SwiftUI
import CoreLocation

public class ContentViewModel:ObservableObject {
    
    @Published var state:LoadingState = .notLoading
    @Published var tideDataApiKey:String!
    
    var configurationProvider:ConfigurationProvider = ConfigurationProvider(configurationSource: LocalConfiguration())
    
    init(state: LoadingState = .notLoading) {
        self.state = state
    }
    
    func fetchConfig() async {
        
        let _ = await self.configurationProvider.fetchConfig()
        do {
            self.tideDataApiKey = try self.configurationProvider.configValue(forKey: .tidalApiSubscriptionKey)
            self.state = .loaded
        } catch {
            self.state = .error
        }
        
    }
    
}

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel(state: .loading)
    
    var body: some View {
        
        VStack {
            switch viewModel.state {
            case .notLoading:
                Text("Welcome")
            case .loading:
                ProgressView()
            case .loaded:

                NavigationSplitView {
                    List {
                        NavigationLink {
                            LocatingUserView(viewModel: LocatingUserViewModel(locationProvider: LocationService(locationManager: CLLocationManager())))
                        } label: {
                            Text("Near me")
                        }
                        
                        NavigationLink {
                            TideStationListView()
                        } label: {
                            Text("All tide stations")
                        }
                    }
                    .navigationTitle("Tidey")
                    
                } detail: {
                    EmptyView()
                }
                .environmentObject(TideStationListViewModel(tideStationAPIService: UKTidalAPI(apiKey: viewModel.tideDataApiKey)))

            case .error:
                Text("There was an error loading the config")
            }
        }
        .task(priority: .high) {
            await viewModel.fetchConfig()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().makeContentView()
    }
}
