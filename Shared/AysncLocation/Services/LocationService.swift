//
//  Blah.swift
//  Tidey
//
//  Created by Ben Reed on 09/05/2023.
//

import Foundation
import CoreLocation

public class LocationService:NSObject, LocationDataProvider {
            
    @Published var state:LocationProviderState = .determiningAuthorisation
    public var locationManager:LocationManager
    
    private var locationProviderContinuation:AsyncStream<LocationProviderState>.Continuation?
    
    required public init(locationManager:LocationManager) {
        
        self.locationManager = locationManager
        super.init()
        
        self.locationManager.delegate = self
        
    }
        
    public func getState() async -> AsyncStream<LocationProviderState> {
        
        return AsyncStream { continuation in
            locationProviderContinuation = continuation
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                locationProviderContinuation?.yield(LocationProviderState.mapAuthorisationStatus(status: locationManager.authorizationStatus))
                continuation.finish()
            case .authorizedAlways,.authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
            @unknown default:
                //TODO: See if this can be handled without force unwrapping
                locationProviderContinuation?.yield(.error)
                continuation.finish()
            }
        }

    }
    
}

extension LocationService:CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let mappedStatus = LocationProviderState.mapAuthorisationStatus(status: self.locationManager.authorizationStatus)
        locationProviderContinuation?.yield(mappedStatus)
        
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationProviderContinuation?.yield(.locationUpdated(location: location))
            locationProviderContinuation?.finish()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationProviderContinuation?.yield(.error)
    }
}
