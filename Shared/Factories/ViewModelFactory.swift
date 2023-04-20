//
//  ViewModelFactory.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import Foundation
import FirebaseRemoteConfig

public class ViewModelFactory:ObservableObject {
    
    var configuration:ConfigurationProvider
    
    required init(configuration:ConfigurationProvider) {
        self.configuration = configuration
    }
    
    func configuredUKTidalAPIService() -> UKTidalAPIService {
            
        guard let subscriptionKey = try? self.configuration.configValue(for: .tidalApiSubscriptionKey) else {
            fatalError("Tidal API Subscription Key not found")
        }
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Ocp-Apim-Subscription-Key":subscriptionKey]
        
        let session = URLSession(configuration: config)
        let tideServiceAPI = UKTidalAPIService(session: session, baseURL: Bundle.main.object(key: .ukTidalApiBaseUrl), urlHelper: URLHelper())
        
        return tideServiceAPI
        
    }
    
    func makeTideStationListViewModel() -> TideStationListViewModel {
        
        return TideStationListViewModel(tideStationAPIService: self.configuredUKTidalAPIService(), configuration: self.configuration)
    }
    
}
