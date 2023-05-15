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
        
        NavigationStack {
            
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
                .navigationTitle("Stations")
                .overlay {
                    if viewModel.viewState == .loading {
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
        
    }
}


struct tideStationAPIService_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().makeTideStationListPreview()
    }
}
