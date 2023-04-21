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
    
    func configuredUKTidalAPIService() -> TideDataLoadable {
            
        guard let subscriptionKey = try? self.configuration.configValue(for: .tidalApiSubscriptionKey) else {
            fatalError("Tidal API Subscription Key not found")
        }
        
        let tideServiceAPI = UKTidalAPI.newInstance(apiKey: subscriptionKey)
        
        return tideServiceAPI
        
    }
    
    func makeTideStationListViewModel() -> TideStationListViewModel {
        
        return TideStationListViewModel(tideStationAPIService: self.configuredUKTidalAPIService())
    }
    
}
