//
//  LocationManager.swift
//  Tidey
//
//  Created by Ben Reed on 10/05/2023.
//

import Foundation
import CoreLocation

public protocol LocationManager {
    
    // CLLocationManager Properties
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }
    var distanceFilter: CLLocationDistance { get set }
    var allowsBackgroundLocationUpdates: Bool { get set }
    var authorizationStatus:CLAuthorizationStatus { get }
    
    // CLLocationManager Methods
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
    // Wrappers for CLLocationManager class functions.
    func isLocationServicesEnabled() -> Bool
    
}

extension CLLocationManager: LocationManager {
    
    public func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}
