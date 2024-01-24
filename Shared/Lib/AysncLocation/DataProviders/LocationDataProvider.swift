//
//  Blah.swift
//  Tidey
//
//  Created by Ben Reed on 09/05/2023.
//

import Foundation
import CoreLocation
import Combine

protocol LocationDataSource {
    func updateLocation() async throws -> Location
}

public typealias Location = CLLocationCoordinate2D

public class LocationDataProvider:NSObject, LocationDataSource {
    
    private typealias LocationUpdateContinuation = CheckedContinuation<Location, Error>
    
    private var locationManager: CLLocationManager
    private var locationUpdateContinuation:LocationUpdateContinuation?
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func updateLocation() async throws -> Location {
        return try await withCheckedThrowingContinuation { [weak self] (continuation: LocationUpdateContinuation) in
            guard let self = self else {
                return
            }
            
            self.locationUpdateContinuation = continuation
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
}

extension LocationDataProvider:CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let loc = locations.last {
            let location = Location(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            locationUpdateContinuation?.resume(returning: location)
            locationUpdateContinuation = nil
        }
        
    }
    
    public func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        locationUpdateContinuation?.resume(throwing: error)
        locationUpdateContinuation = nil
    }
    
}
