//
//  TestConfigurationProvider.swift
//  Tidey
//
//  Created by Ben Reed on 22/09/2023.
//

import Foundation
import Combine

public class TestConfiguration:ConfigurationSource {
    
    func fetchConfigurationData() -> Future<ApplicationState, ConfigurationError> {
        
        Future { promise in
            promise(.success(.configLoaded))
        }
    }
    
    func configValue(forKey key: ConfigurationKey) -> Future<String, ConfigurationError> {
        
        return Future { promise in
            
            let bundle = Bundle.main
            let value = bundle.object(forInfoDictionaryKey: key.rawValue) as? String
            
            if let value = value {
                promise(.success(value))
            }else{
                promise(.failure(.noData))
            }
                    
        }
    }
}
