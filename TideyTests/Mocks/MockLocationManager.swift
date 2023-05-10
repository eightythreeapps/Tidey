//
//  MockLocationManager.swift
//  Tidey
//
//  Created by Ben Reed on 10/05/2023.
//

import Foundation
import CoreLocation

class MockLocationManager: LocationManager {
    
    var mockLocations:[CLLocation] = [
        CLLocation(latitude: 50.3344340, longitude: -4.7712680),
        CLLocation(latitude: 50.3344210, longitude: -4.7712630),
        CLLocation(latitude: 50.3344080, longitude: -4.7712580),
        CLLocation(latitude: 50.3343720, longitude: -4.7712490),
        CLLocation(latitude: 50.3343590, longitude: -4.7712450),
        CLLocation(latitude: 50.3343160, longitude: -4.7712320),
        CLLocation(latitude: 50.3342980, longitude: -4.7712270),
        CLLocation(latitude: 50.3342800, longitude: -4.7712220),
        CLLocation(latitude: 50.3342360, longitude: -4.7712130)
    ]
    
    var location: CLLocation?
    var delegate: CLLocationManagerDelegate?
    var distanceFilter: CLLocationDistance = 10
    var pausesLocationUpdatesAutomatically: Bool = true
    var allowsBackgroundLocationUpdates: Bool = true
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    func requestWhenInUseAuthorization() {}
    
    func startUpdatingLocation() {}
    
    func stopUpdatingLocation() {}
    
    func isLocationServicesEnabled() -> Bool {
        return true
    }
    
    //Convienience initializers to overide properties for testing
    convenience init(authorizationStatus:CLAuthorizationStatus) {
        self.init()
        self.authorizationStatus = authorizationStatus
    }
    
    convenience init(location:CLLocation) {
        self.init()
        self.location = location
    }
}
