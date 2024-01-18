//
//  ConfigurationProvider.swift
//  Tidey
//
//  Created by Ben Reed on 25/04/2023.
//

import Foundation
import Combine

struct ApplicationConfiguration {
    var apiKey:String
    var baseURL:String
}

@MainActor
public class ConfigurationProvider:ObservableObject {
    
    private var configurationSource:ConfigurationSource!
    @Published var state:ConfigurationState = .error(error: .noData)
    
    init(configurationSource:ConfigurationSource) {
        self.configurationSource = configurationSource
    }
        
    func fetchConfig() async {
        self.state = try! await self.configurationSource.fetchConfigurationData()
    }
    
    func configValue(forKey key:ConfigurationKey) async throws -> String {
        return try! await self.configurationSource.configValue(forKey: key)
    }
    
    
}
