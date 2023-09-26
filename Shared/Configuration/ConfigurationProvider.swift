//
//  ConfigurationProvider.swift
//  Tidey
//
//  Created by Ben Reed on 25/04/2023.
//

import Foundation
import Combine

public class ConfigurationProvider:ObservableObject {
    
    private var configurationSource:ConfigurationSource!
    
    init(configurationSource:ConfigurationSource) {
        self.configurationSource = configurationSource
    }
        
    func fetchConfig() -> Future<LoadingState, ConfigurationError> {
        return self.configurationSource.fetchConfigurationData()
    }
    
    func configValue(forKey key:ConfigurationKey) -> Future<String, ConfigurationError> {
        return self.configurationSource.configValue(forKey: key)
    }
    
    
}
