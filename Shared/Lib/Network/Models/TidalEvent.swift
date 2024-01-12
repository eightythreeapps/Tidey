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
    
    func iconName() -> String {
        switch self {
        case .highWater:
            return "arrow.up.circle.fill"
        case .lowWater:
            return "arrow.down.circle.fill"
        case .unknown:
            return "questionmark.circle.fill"
        }
        
    }
    
}

enum EventDateType {
    case eventDate
    case updatedDate
}

struct TidalEvent:Identifiable, Codable {
        
    var id:UUID = UUID()
    var event:Event
        
    public func getFormattedEventDate(format:String = "HH:MM dd MMM YYYY") -> String {
    
        let date = self.event.dateTime.toDate(style: .iso(.init(strict: true)), region: .local)
        
        if let formattedDate = date?.toFormat(format) {
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
    
    public func getEventDate() -> Date {
        
        guard let date = stringToDate(dateString: event.dateTime) else {
            return Date()
        }
        
        return date
        
    }
    
    public func getEventHeight() -> String {
        return String(format: "%.2f", event.height)
    }
 
}

private extension TidalEvent {
    
    func stringToDate(dateString:String) -> Date? {
        
        let date = dateString.toDate(style: .iso(.init(strict: true)), region: .local)
        return date?.date
    }
    
}
