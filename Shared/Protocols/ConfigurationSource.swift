//
//  ConfigurationSource.swift
//  Tidey
//
//  Created by Ben Reed on 25/04/2023.
//

import Foundation
import Combine

enum ConfigurationError:Error {
    case invalidConfigKey
    case noData
    case decodingError
    case fetchError
}

enum ConfigurationKey: String {
    case tidalApiSubscriptionKey = "TidalDiscoveryAPISubscriptionKeyPrimary"
    case tidalApiBaseUrl = "UKTidalAPIBaseURL"
}

protocol ConfigurationProvider {
    func configValue(forKey key:ConfigurationKey) -> Future<String, ConfigurationError>
    func fetchConfigurationData() -> Future<ApplicationState, ConfigurationError>
}
