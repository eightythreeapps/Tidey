//
//  StationDetailView.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import SwiftUI
import CoreLocation
import Charts

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
                    await viewModel.getEventsForStation(stationId:id)
                }
            }else if let location = location {
                
                Task {
                    await viewModel.findStationClosestToLocation(location: location)
                }
            }
        }
    
    }
}

struct StationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().makeStationDetailView()
    }
}
