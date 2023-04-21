//
//  TidalEvent.swift
//  Tidey
//
//  Created by Ben Reed on 14/04/2023.
//

import Foundation

import Foundation
import SwiftDate

typealias TidalEvents = [TidalEvent]

enum TideEventType {
    case highWater
    case lowWater
    case unknown
}

struct TidalEvent:Identifiable {
        
    var id:UUID = UUID()
    var event:Event
        
    public func getFormattedDate() -> String {
    
        let date = self.event.dateTime.toDate(style: .iso(.init(strict: true)), region: .local)
        
        if let formattedDate = date?.toFormat("hh:MM dd MMM YYYY") {
            return formattedDate
        }
        
        return "Unknown"
        
    }
    
    public func getType() -> TideEventType {
        if event.eventType == "HighWater" {
            return .highWater
        } else if event.eventType == "LowWater" {
            return .lowWater
        } else {
            return .unknown
        }
    }
    
    public func getFormttedEventName() -> String {
        if event.eventType == "HighWater" {
            return "High Tide"
        } else if event.eventType == "LowWater" {
            return "Low Tide"
        } else {
            return "Unknown"
        }
    }
 
}

