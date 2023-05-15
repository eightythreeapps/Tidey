//
//  LocalConfiguration.swift
//  Tidey
//
//  Created by Ben Reed on 25/04/2023.
//

import Foundation
import Combine

public class LocalConfiguration:ConfigurationSource {
    
    var configurationState:LoadingState = .notLoading
    
    func fetchConfigurationData() -> Future<LoadingState, ConfigurationError> {
        
        Future { promise in
            promise(.success(.loaded))
        }
    }
    
    func configValue(forKey key: ConfigurationKey) -> String {
        
        let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String
        return value ?? ""
    }
}

public class TestConfiguration:ConfigurationSource {
    
    var configurationState:LoadingState = .notLoading
    
    func fetchConfigurationData() -> Future<LoadingState , ConfigurationError> {
        
        Future { promise in
            promise(.success(.loaded))
        }
    }
    
    func configValue(forKey key: ConfigurationKey) -> String {
        
        let bundle = BundleFactory.bundleFor(classType: self)
        let value = bundle.object(forInfoDictionaryKey: key.rawValue) as? String
        
        return value ?? ""
    }
}
