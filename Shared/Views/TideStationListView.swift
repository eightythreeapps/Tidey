//
//  TideStationListView.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import SwiftUI
import GeoJSON
import SwiftDate
import CoreLocation

protocol TideDataConsuming {
    var tideDataProvider:TideDataProvider { get set }
}

protocol StateRepresentableView {
    var state:ViewState { get set }
}

struct TideStationListView: View, StateRepresentableView, TideDataConsuming {
    
    var tideDataProvider:TideDataProvider
    
    @State var tideStations:TideStations = []
    @State var state:ViewState = .loadingData
    
    var body: some View {
        
        List(tideStations) { station in
            
            NavigationLink {
                TideStationDetailView(tideDataProvider: tideDataProvider, station: station)
            } label: {
                Text(station.getStationName())
            }

        }
        .navigationTitle("Tide Stations")
        .overlay {
            ViewStateView(state: $state)
        }
        .task {
            self.state = .loadingData
            do {
                tideStations = try await tideDataProvider.getStations()
                self.state = .loaded
            } catch {
                self.state = .error
            }
        }
        
    }
}


#Preview {    
    NavigationView {
        TideStationListView(tideDataProvider: MockTideDataProvider())
    }
}
