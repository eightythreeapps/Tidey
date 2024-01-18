//
//  RootView.swift
//  Tidey
//
//  Created by Ben Reed on 18/01/2024.
//

import SwiftUI

struct RootView: View {
    
    var config:ApplicationConfiguration
    
    var body: some View {
        
        NavigationSplitView {
            TideStationListView(tideDataProvider: TideDataAPI(host: config.baseURL,
                                                              dataParser: TideDataGeoJSONParser(),
                                                              apiKey: config.apiKey))
        } detail: {
            EmptyView()
        }
        
    }
}



#Preview {
    RootView(config: ApplicationConfiguration(apiKey: "", baseURL: ""))
}
