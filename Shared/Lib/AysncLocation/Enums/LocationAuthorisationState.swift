//
//  Blah.swift
//  Tidey
//
//  Created by Ben Reed on 09/05/2023.
//

import Foundation
import CoreLocation

public enum LocationProviderState: Equatable {
    
    case denied(status:CLAuthorizationStatus)
    case authorised(status:CLAuthorizationStatus)
    case determiningAuthorisation
    case determiningUserLocation
    case locationUpdated(location:CLLocation)
    case error
        
    static func mapAuthorisationStatus(status:CLAuthorizationStatus) -> LocationProviderState {
        switch status {
        case .denied, .restricted:
            return .denied(status: status)
        case .authorizedAlways,.authorizedWhenInUse:
            return .authorised(status: status)
        case .notDetermined:
            return .determiningAuthorisation
        @unknown default:
            return .error
        }
    }
}
