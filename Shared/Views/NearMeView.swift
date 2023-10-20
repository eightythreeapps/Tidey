//
//  NearMeView.swift
//  Tidey
//
//  Created by Ben Reed on 21/09/2023.
//

import SwiftUI
import MapKit

struct NearMeView: View {
    
    @EnvironmentObject var viewModel:NearMeViewModel
    
    var body: some View {
        
        VStack {
            
            if let station = viewModel.selectedStation {
                    
                Text("Current location")
                Text("St. Austell, Cornwall")
                    .font(.title)
                Text("Nearest tide station")
                
                Text(station.getStationName())
                
                HStack {
                    
                    RecentTideTimeView(tideTime: .last, tideLevel: .high, dateTime: "04:37")
                    
                    Divider()
                        .frame(height: 85)
                    
                    RecentTideTimeView(tideTime: .next, tideLevel: .low, dateTime: "09:27")
                    
                }
                .background(.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding()
            
            }else {
                Text(viewModel.statusMessage)
            }
            
        }
        
    }
}

#Preview {
    NearMeView()
        .environmentObject(
            NearMeViewModel(tideStationDataProvider: MockDataProvider.PreviewProvider.TideDataProvider,
                                     locationService: LocationService(locationManager: MockLocationManager(authorizationStatus: .authorizedAlways)))
        )
}
