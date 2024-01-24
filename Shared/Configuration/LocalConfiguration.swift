//
//  LocalConfiguration.swift
//  Tidey
//
//  Created by Ben Reed on 25/04/2023.
//

import Foundation
import Combine

public class LocalConfiguration:ConfigurationSource {
    
    func fetchConfigurationData() async throws -> ConfigurationState {
        
        let bundle = Bundle.main
        guard let apiKey = bundle.object(forInfoDictionaryKey: ConfigurationKey.tidalApiSubscriptionKey.rawValue) as? String,
              let baseURL = bundle.object(forInfoDictionaryKey: ConfigurationKey.tidalApiBaseUrl.rawValue) as? String else {
            
            return ConfigurationState.error(error: .noData)
            
        }
        
        return .configured(config: ApplicationConfiguration(apiKey: apiKey, baseURL: baseURL))
        
    }
    
    func configValue(forKey key: ConfigurationKey) async throws -> String {
        
        if let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String {
            return value
        }else{
            throw ConfigurationError.noData
        }
        
    }
}
