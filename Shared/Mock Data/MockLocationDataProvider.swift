//
//  MockLocationDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 10/05/2023.
//

import Foundation

//public class MockLocationDataProvider:LocationDataProvider {
//    
//    public var locationManager: LocationManager
//    
//    required public init(locationManager: LocationManager) {
//        self.locationManager = locationManager
//    }
//    
//    public func getState() async -> AsyncStream<LocationProviderState> {
//        
//        return AsyncStream { continuation in
//            
//            switch locationManager.authorizationStatus {
//                
//            case .denied, .restricted:
//                continuation.yield(.denied(status: locationManager.authorizationStatus))
//            case .authorizedAlways, .authorizedWhenInUse:
//                continuation.yield(.denied(status: locationManager.authorizationStatus))
//            case .notDetermined:
//                continuation.yield(.determiningAuthorisation)
//            @unknown default:
//                continuation.yield(.error)
//            }
//            
//            continuation.finish()
//        }
//        
//    }
//    
//    
//}
