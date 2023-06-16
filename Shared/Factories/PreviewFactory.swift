//
//  PreviewFactory.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import SwiftUI
import GeoJSON

public class PreviewFactory {
    
    func makeContentView() -> some View {
        return ContentView()
    }
    
    @MainActor func makeStationDetailView() -> some View {
        return StationDetailView(stationName: "StationName", id: "0011")
            .environmentObject(TideStationListViewModel(tideStationAPIService: MockTideDataService(session: URLSession.shared, baseURL: "", urlHelper: URLHelper())))
    }

    @MainActor func makeTideStationListPreview() -> some View {
        
        return TideStationListView()
            .environmentObject(TideStationListViewModel(tideStationAPIService: MockTideDataService(session: URLSession.shared, baseURL: "", urlHelper: URLHelper())))
    }
    
    @MainActor func makeTideStationMapPreview() -> some View {
        
        return StationMapView()
            .environmentObject(TideStationListViewModel(tideStationAPIService: MockTideDataService(session: URLSession.shared, baseURL: "", urlHelper: URLHelper())))
    }
    
}
