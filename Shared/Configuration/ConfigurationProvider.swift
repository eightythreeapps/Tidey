//
//  ConfigurationProvider.swift
//  Tidey
//
//  Created by Ben Reed on 25/04/2023.
//

import Foundation
import Combine

public class ConfigurationProvider:ObservableObject {
    
    @Published var state:LoadingState = .notLoading
    
    private var configurationSource:ConfigurationSource!
    private var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(configurationSource:ConfigurationSource) {
        self.configurationSource = configurationSource
        self.state = configurationSource.configurationState
    }
        
    //Needs to be Main actor as Firebase calls some UI APIs so needs to be on the main thread to silence the warnings.
    @MainActor
    func fetchConfig() async -> LoadingState {
        
        do {
            return try await self.configurationSource.fetchConfigurationData().value
        } catch {
            return .error
        }
        
    }
    
    func configValue(forKey key:ConfigurationKey) throws -> String {
        
        do {
            return try self.configurationSource.configValue(forKey: key)
        } catch (let error) {
            throw error
        }
        
    }
}
