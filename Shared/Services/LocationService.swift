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
    var locationManager:CLLocationManager
    
    private var locationProviderContinuation:AsyncStream<LocationProviderState>.Continuation?
    
    init(locationManager:CLLocationManager) {
        
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
            case .authorizedAlways,.authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
            @unknown default:
                //TODO: See if this can be handled without force unwrapping
                locationProviderContinuation?.yield(.error)
            }
        }

    }
    
}

extension LocationService:CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let mappedStatus = LocationProviderState.mapAuthorisationStatus(status: manager.authorizationStatus)
        locationProviderContinuation?.yield(mappedStatus)
        
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            locationProviderContinuation?.yield(.locationUpdated(location: location))
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationProviderContinuation?.yield(.error)
    }
}
