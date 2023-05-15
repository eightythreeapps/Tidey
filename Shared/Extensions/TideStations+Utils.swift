//
//  TideStationProvder.swift
//  Tidey
//
//  Created by Ben Reed on 03/05/2023.
//

import Foundation
import CoreLocation
import GeoJSON
import Combine

struct StationDistance {
    var distance:CLLocationDistance
    var stationID:UUID
}

enum SortOrder {
    case ascending
    case descending
}

extension TideStations {

    func getNearestStation(to userLocation:CLLocation) -> TideStation? {
        
        let sortedStations = self.sortedGeographically(disatanceFrom: userLocation, order: .ascending)
        let closest = sortedStations?.first
        return closest
        
    }
    
    func sortedAlphabetically(sortOrder:SortOrder) -> TideStations {
        let sorted = self.sorted { station1, station2 in
            
            if sortOrder == .ascending {
                return station1.getStationName().localizedCompare(station2.getStationName()) == .orderedAscending
            }else{
                return station1.getStationName().localizedCompare(station2.getStationName()) == .orderedDescending
            }

        }
        return sorted
    }
    
    func sortedGeographically(disatanceFrom location:CLLocation, order:SortOrder) -> TideStations? {
        
        let sorted = self.sorted { station1, station2 in
            if let distance1 = station1.getLocation()?.distance(from: location), let distance2 = station2.getLocation()?.distance(from: location) {
                
                if order == .ascending {
                    return distance1 < distance2
                }else{
                    return distance1 > distance2
                }
                
            }
            return false
        }
        
        return sorted
                
    }

}
