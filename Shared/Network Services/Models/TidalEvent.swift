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
    
    public func getFormttedEventName() -> String {
        return event.eventType
    }
 
}

