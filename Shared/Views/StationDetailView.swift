//
//  StationDetailView.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import SwiftUI
import CoreLocation
import Charts
import MapKit

struct StationDetailView: View {
    
    @EnvironmentObject var viewModel:TideStationListViewModel
    
    var location:CLLocation?
    var stationName:String?
    var id:String?
    
    var body: some View {
        
        VStack {
            
            if viewModel.viewState == .loading {
                ProgressView()
            } else if viewModel.viewState == .loaded {
                
                Map(coordinateRegion: $viewModel.mapRegion,
                    interactionModes: [],
                    showsUserLocation: false,
                    userTrackingMode: .none,
                    annotationItems: [viewModel.getStation(stationId: id ?? "")]
                )
                {
                    MapPin(coordinate: $0.coordinate)
                }
                
                List(viewModel.tidalEvents) { event in
                    
                    HStack {
                        
                        if event.getType() == .highWater {
                            Image(systemName: "arrow.up.circle")
                                .padding(EdgeInsets(top: 0.0,
                                                    leading: 0.0,
                                                    bottom: 0.0,
                                                    trailing: 4.0))
                        }else{
                            Image(systemName: "arrow.down.circle")
                                .padding(EdgeInsets(top: 0.0,
                                                    leading: 0.0,
                                                    bottom: 0.0,
                                                    trailing: 4.0))
                        }
                        
                        VStack(alignment: .leading) {
                            Text(event.getFormttedEventName())
                                .font(.headline)
                            Text(event.getFormattedEventDate())
                                .font(.subheadline)
                        }
                        
                    }
                    
                }
            } else if viewModel.viewState == .error {
                Text("Error loading tide events")
            }
                
        }
        .navigationTitle(viewModel.stationName)
        .onAppear {
            if let id = id {
                Task {
                    await viewModel.getDetailsForStation(stationId:id)
                }
            }else if let location = location {
                
                Task {
                    await viewModel.findStationClosestToLocation(location: location)
                }
            }
        }
    
    }
}

#Preview {
    StationDetailView(location: nil, stationName: "Station Name", id: "0008")
        .environmentObject(TideStationListViewModel(tideStationDataProvider: MockDataProvider.PreviewProvider.TideDataProvider))
}
