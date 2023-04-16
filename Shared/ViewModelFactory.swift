//
//  ViewModelFactory.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import Foundation

public class ViewModelFactory {
    
    static func configuredUKTidalAPIService() -> UKTidalAPIService {
        
        let urlHelper = URLHelper()
        let subscriptionKey = ProcessInfo.processInfo.environment["OcpApimSubscriptionKey"]
            
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":subscriptionKey ?? ""]
        
        let session = URLSession(configuration: config)
        let tideServiceAPI = UKTidalAPIService(session: session, baseURL: Bundle.main.object(key: .ukTidalApiBaseUrl), urlHelper: urlHelper)
        
        return tideServiceAPI
    }
    
    static func makeTideStationListViewModel() -> TideStationListViewModel {
        
        return TideStationListViewModel(tideStationAPIService: ViewModelFactory.configuredUKTidalAPIService())
    }
    
}
