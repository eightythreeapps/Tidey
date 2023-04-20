//
//  PreviewFactory.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseRemoteConfig

public class PreviewFactory {
    
    static var configurationProvider:ConfigurationProvider = {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        return ConfigurationProvider(remoteConfig:remoteConfig)
    }()
        
    static func configuredTideAPI() -> UKTidalAPI {
        
        let subscriptionKey = ProcessInfo.processInfo.environment["OcpApimSubscriptionKey"]!
            
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":subscriptionKey]
        
        let session = URLSession(configuration: config)
        let baseURL = Bundle.main.object(key: .ukTidalApiBaseUrl)
        
        let tideAPIService = UKTidalAPIService(session: session, baseURL: baseURL, urlHelper: URLHelper())
        
        return tideAPIService
    }
    
    static func makeStationDetailView() -> some View {
        
        return StationDetailView(stationName: "StationName", id: "0001")
            .environmentObject(TideStationListViewModel(tideStationAPIService: PreviewFactory.configuredTideAPI(),
                                                        configuration: PreviewFactory.configurationProvider))
        
    }

    static func makeTideStationListPreview() -> some View {
        
        return TideStationListView()
            .environmentObject(TideStationListViewModel(tideStationAPIService: PreviewFactory.configuredTideAPI(),
                                                        configuration: PreviewFactory.configurationProvider))
    }
    
}
