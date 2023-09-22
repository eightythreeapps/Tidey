//
//  StationMapView.swift
//  Tidey
//
//  Created by Ben Reed on 16/05/2023.
//

import SwiftUI
import MapKit

struct StationMapView: View {
    
    @EnvironmentObject var viewModel:TideStationListViewModel

    var body: some View {
        Map(coordinateRegion: $viewModel.mapRegion)
    }
    
}

#Preview {
    StationMapView()
        .environmentObject(TideStationListViewModel(tideStationDataProvider:MockDataProvider.PreviewProvider.TideDataProvider))
}
