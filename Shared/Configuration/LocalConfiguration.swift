//
//  LocalConfiguration.swift
//  Tidey
//
//  Created by Ben Reed on 25/04/2023.
//

import Foundation
import Combine

public class LocalConfiguration:ConfigurationSource {
    
    func fetchConfigurationData() -> Future<ApplicationState, ConfigurationError> {
        
        Future { promise in
            promise(.success(.configLoaded))
        }
        
    }
    
    func configValue(forKey key: ConfigurationKey) -> Future<String, ConfigurationError> {
        
        return Future { promise in
                
            if let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String {
                promise(.success(value))
            }else{
                promise(.failure(.noData))
            }
            
        }
        
    }
}
