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

struct StationMapView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().makeTideStationMapPreview()
    }
}
