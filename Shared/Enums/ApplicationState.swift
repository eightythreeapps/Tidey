//
//  ApplicationState.swift
//  Tidey
//
//  Created by Ben Reed on 11/01/2024.
//

import Foundation

enum ConfigurationState {
    case loadingConfig
    case configured(config:ApplicationConfiguration)
    case error(error:ConfigurationError)
}

enum ApplicationError:LocalizedError {
    case dataLoadingError
    case locationError
    case unknown
}
