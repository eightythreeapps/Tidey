//
//  Blah.swift
//  Tidey
//
//  Created by Ben Reed on 09/05/2023.
//

import Foundation
import CoreLocation
import Combine

public class LocationService:NSObject {
            
    @Published var authorisationState:LocationProviderState = .determiningAuthorisation
    
    @Published var currentLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    @Published var currentHeading:CLHeading?
    @Published var error:Error?
    
    private var locationManager:LocationManager
    
    required public init(locationManager:LocationManager) {
        
        self.locationManager = locationManager
        super.init()
        
        self.locationManager.delegate = self
        
    }
        
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startMonitoringLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopMonitoringLocation() {
        locationManager.stopUpdatingLocation()
    }

}

extension LocationService:CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorisationState = LocationProviderState.mapAuthorisationStatus(status: self.locationManager.authorizationStatus)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        self.currentLocation = location

    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO: Implement logic to clear old errors
        self.error = error
    }
}
