//
//  TideStationMapView.swift
//  Tidey
//
//  Created by Ben Reed on 21/09/2023.
//

import SwiftUI
import MapKit
import CoreLocation

struct TideStationsMapView: View {
    
    @EnvironmentObject var viewModel:TideStationListViewModel
    
    var body: some View {
        
        VStack {
            if viewModel.viewState == .loading {
                ProgressView()
            } else if viewModel.viewState == .loaded {
                
                Map(coordinateRegion: $viewModel.mapRegion,
                    interactionModes: [.all],
                    showsUserLocation: false,
                    userTrackingMode: .none,
                    annotationItems: viewModel.stations
                )
                {
                    MapMarker(coordinate: $0.coordinate)
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

#Preview {
    TideStationsMapView()
}
