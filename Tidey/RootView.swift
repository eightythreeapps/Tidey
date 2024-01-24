//
//  RootView.swift
//  Tidey
//
//  Created by Ben Reed on 18/01/2024.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var applicationDataModel:ApplicationDataModel
    
    var body: some View {
        
        NavigationSplitView {
            
            List(selection: $applicationDataModel.selectedStation) {
                ForEach(applicationDataModel.searchResults) { station in
                    NavigationLink(value: station) {
                        Text(station.getStationName())
                    }
                }
            }
            .navigationTitle("Tide Stations")
            .task {
                await applicationDataModel.allTideStations()
            }
            
        } detail: {
            TideStationDetailView(station: $applicationDataModel.selectedStation)
        }
        .searchable(text: $applicationDataModel.searchText)
        
    }
}

#Preview {
    RootView()
        .environmentObject(ApplicationDataModel.PreviewApplicationModel())
}
