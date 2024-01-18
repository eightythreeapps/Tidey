//
//  TestConfigurationProvider.swift
//  Tidey
//
//  Created by Ben Reed on 22/09/2023.
//

import Foundation
import Combine

public class TestConfiguration:ConfigurationSource {
    
    func fetchConfigurationData() async throws -> ConfigurationState {
        return ConfigurationState.loadingConfig
    }
    
    func configValue(forKey key: ConfigurationKey) async throws -> String {
        
        if let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String {
            return value
        }else{
            throw ConfigurationError.noData
        }
        
    }
}
