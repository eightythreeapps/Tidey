//
//  AppSection.swift
//  Tidey
//
//  Created by Ben Reed on 22/09/2023.
//

import Foundation

enum MenuItem:String, CaseIterable, Identifiable {
    
    case nearMe = "Near me"
    case allStations = "All Stations"
    case mapView = "Map"
    
    var id:String {
        return self.rawValue
    }
}

