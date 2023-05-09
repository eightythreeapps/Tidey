//
//  TideStation.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import Foundation
import GeoJSON
import CoreLocation

typealias TideStations = [TideStation]

struct TideStation:Identifiable {
        
    var id:UUID = UUID()
    var feature:Feature
    
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


