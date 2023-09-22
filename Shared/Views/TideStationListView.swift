//
//  TideStationListView.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import SwiftUI
import GeoJSON
import SwiftDate

struct TideStationListView: View {
    
    @EnvironmentObject var viewModel:TideStationListViewModel
    
    var body: some View {
        
        VStack {
            
            if viewModel.viewState == .error {
                Text("Error loading stuff")
            } else {
                
                List(viewModel.stations) { station in
                    NavigationLink {
                        StationDetailView(stationName: station.getStationName(),
                                          id: station.getStationId())
                    } label: {
                        Text(station.getStationName())
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Stations")
                .overlay {
                    if viewModel.viewState == .loading {
                        ProgressView()
                    }
                }
            }
            
        }.onAppear {
            Task {
                await viewModel.loadData()
            }
        }
        
    }
}


#Preview {    
    TideStationListView()
        .environmentObject(TideStationListViewModel(tideStationDataProvider: MockDataProvider.PreviewProvider.TideDataProvider))
}
