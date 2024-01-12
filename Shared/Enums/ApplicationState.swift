//
//  ApplicationState.swift
//  Tidey
//
//  Created by Ben Reed on 11/01/2024.
//

import Foundation

enum ApplicationState {
    case loadingConfig
    case configLoaded
    case notConfigured
    case configured(apiKey:String, baseUrl:String)
}

enum ApplicationError:LocalizedError {
    case dataLoadingError
    case locationError
    case unknown
}
