//
//  TideStation.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import Foundation
import GeoJSON
import MapKit
import CoreLocation

typealias TideStations = [TideStation]

struct TideStation:Identifiable {
        
    var id:UUID = UUID()
    var feature:Feature
    var coordinate:CLLocationCoordinate2D {
        get {
            getLocation()?.coordinate ?? CLLocationCoordinate2D()
        }
    }
    
    public func getStationId() -> String? {
        
        if let id = feature.properties?.data["Id"]?.value as? String {
            return id
        }
        
        return nil
        
    }
    
    public func getStationName() -> String {
        
        if let name = feature.properties?.data["Name"]?.value as? String {
            return name.capitalized
        }
        
        return "Unknown"
        
    }
    
    public func getCoordinateRegion() -> MKCoordinateRegion {
        
        if let location = getLocation() {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                     longitude: location.coordinate.longitude),
                                      span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }else{
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0,
                                                              longitude: 0.0),
                                      span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
                
    }
    
    public func getLocation() -> CLLocation? {
        
        if let geometry = feature.geometry {
            switch geometry {
            case .point(let position):
                return CLLocation(latitude: position.coordinates.latitude,
                                  longitude: position.coordinates.longitude)
            case .multiPoint(_),.lineString(_),.multiLineString(_),.polygon(_),.multiPolygon(_),.geometryCollection(_):
                print("Do nothing")
            }
        }
        
        return nil
        
    }
 
}


