//
//  Loadable.swift
//  Tidey
//
//  Created by Ben Reed on 26/04/2023.
//

import Foundation
import CoreLocation

enum ApplicationState {
    case loadingConfig
    case configLoaded
    case notConfigured
    case configured(apiKey:String)
}

enum ApplicationError:LocalizedError {
    case dataLoadingError
    case locationError
    case unknown
}
