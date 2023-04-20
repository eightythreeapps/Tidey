//
//  Configuration.swift
//  Tidey
//
//  Created by Ben Reed on 19/04/2023.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseRemoteConfig

enum ConfigState {
    case notLoaded
    case loading
    case loaded
    case error
}

enum ConfigurationError:Error {
    case invalidConfigKey
    case noData
    case decodingError
}

enum RemoteConfigurationKey: String {
    case tidalApiSubscriptionKey = "TidalDiscoveryAPISubscriptionKeyPrimary"
}

public class ConfigurationProvider:ObservableObject {
    
    @Published var state:ConfigState = .notLoaded
    
    private var remoteConfig:RemoteConfig!
    
    required init(remoteConfig:RemoteConfig) {
        self.remoteConfig = remoteConfig
    }
    
    func fetchConfig() {
        
        self.state = .loading
        
        self.remoteConfig.fetchAndActivate { (status, error) -> Void in
            switch status {
            case .successFetchedFromRemote:
                self.state = .loaded
            case .successUsingPreFetchedData:
                self.state = .loaded
            case .error:
                self.state = .error
                print(error?.localizedDescription)
            @unknown default:
                self.state = .error
            }
        }
        
    }
    
    func configValue(for key:RemoteConfigurationKey) throws ->  String {
        
        do {
            let value = self.remoteConfig.configValue(forKey: key.rawValue)
            let decodedValue = try decodeValue(data: value.dataValue)
            return decodedValue
        } catch {
            throw error
        }
        
    }
    
    func decodeValue(data:Data) throws -> String {
    
        if data.isEmpty {
            throw ConfigurationError.noData
        }
        
        guard let decodedString = String(data: data, encoding: .utf8) else {
            throw ConfigurationError.decodingError
        }
        
        return decodedString
        
    }
    
    
}
