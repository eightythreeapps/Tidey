//
//  RemoteConfiguration.swift
//  Tidey
//
//  Created by Ben Reed on 25/04/2023.
//

import Foundation
import Combine

public class RemoteConfiguration:ConfigurationSource {
   
    var configurationState:LoadingState = .notLoading
    
    func configValue(forKey key: ConfigurationKey) throws -> String {
        
        return "Error"
        
    }
    
    func fetchConfigurationData() -> Future<LoadingState, ConfigurationError> {
        
        Future { promise in
            promise(.failure(.fetchError))
        }
    }

}
