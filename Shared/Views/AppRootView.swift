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
    
    var body: some View {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            TabView {
                
                ForEach(MenuItem.allCases) { menuItem in
                    
                    switch menuItem {
                        
                    case .nearMe:
                        NearMeView()
                            .tabItem {
                                Text(menuItem.rawValue)
                            }
                            .tag(menuItem.id)
                    case .allStations:
                        
                        NavigationStack {
                            TideStationListView()
                                .environmentObject(tideStationListViewModel)
                        }
                        .tabItem {
                            Text(menuItem.rawValue)
                        }
                        .tag(menuItem.id)
                        
                    case .mapView:
                        
                        TideStationsMapView()
                            .environmentObject(tideStationListViewModel)
                            .tabItem {
                                Text(menuItem.rawValue)
                            }
                        
                    }
                    
                }
            
            }
            
        }else{
            NavigationSplitView {
                List(MenuItem.allCases, selection: $selectedMenuItem) { menuItem in
                    NavigationLink(menuItem.rawValue, value: menuItem)
                }
            } content: {
                switch selectedMenuItem {
                case .nearMe:
                    Text("Near me")
                case .allStations:
                    TideStationListView()
                        .environmentObject(tideStationListViewModel)
                case .none:
                    Text("Hmmm...")
                case .some(.mapView):
                    Text("Maps!")
                }
            } detail: {
                Text("Detail view")
            }
        }

    }
}

#Preview {
    AppRootView()
        .environmentObject(TideStationListViewModel(tideStationDataProvider:MockDataProvider.PreviewProvider.TideDataProvider))
}
