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
            return name
        }
        
        return "Unknown"
        
    }
 
}


