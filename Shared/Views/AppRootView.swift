//
//  AppRootView.swift
//  Tidey
//
//  Created by Ben Reed on 19/09/2023.
//

import SwiftUI

struct AppRootView: View {
    
    @EnvironmentObject var tideStationListViewModel:TideStationListViewModel
    @State var selectedMenuItem:MenuItem?
    
    @State var columVisibility:NavigationSplitViewVisibility = .detailOnly
    
    var body: some View {
        
        NavigationSplitView(columnVisibility:$columVisibility) {
            
            List(MenuItem.allCases) { menuItem in
                NavigationLink(menuItem.rawValue, value: menuItem)
            }
            .listStyle(.sidebar)
            .navigationDestination(for: MenuItem.self) { menuItem in
                switch menuItem {
                case .allStations:
                    TideStationsMapView()
                        .environmentObject(tideStationListViewModel)
                case .nearMe:
                    NearMeView()
                        .environmentObject(tideStationListViewModel)
                }
            }
            
        } detail: {
            NearMeView()
                .environmentObject(tideStationListViewModel)
        }


    }
}

#Preview {
    AppRootView()
        .environmentObject(TideStationListViewModel(tideStationDataProvider:MockDataProvider.PreviewProvider.TideDataProvider))
}
