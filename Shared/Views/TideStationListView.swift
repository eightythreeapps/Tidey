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

struct TideStationListView: View {
    
    @EnvironmentObject var viewModel:NearMeViewModel
    
    var body: some View {
        
        VStack {
            Text("List view")
        }
        
    }
}


#Preview {    
    TideStationListView()
        .environmentObject(
            NearMeViewModel(tideStationDataProvider: MockDataProvider.PreviewProvider.TideDataProvider,
                                     locationService: LocationService(locationManager: MockLocationManager(authorizationStatus: .authorizedAlways)))
        )
}
