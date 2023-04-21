//
//  PreviewFactory.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseRemoteConfig
import GeoJSON

public class PreviewFactory {
    
    func makeContentView() -> some View {
        return ContentView()
    }
    
    func makeStationDetailView() -> some View {
        return StationDetailView(stationName: "StationName", id: "0001")
            .environmentObject(TideStationListViewModel(tideStationAPIService: MockTideDataService()))
    }

    func makeTideStationListPreview() -> some View {
        
        return TideStationListView()
            .environmentObject(TideStationListViewModel(tideStationAPIService: MockTideDataService()))
    }
    
}
