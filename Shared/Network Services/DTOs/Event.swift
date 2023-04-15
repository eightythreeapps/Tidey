//
//  TidalEvent.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 13/04/2023.
//

import Foundation

// MARK: - TidalEvent
public struct Event: Codable, Equatable, Identifiable {
    public var id:UUID = UUID()
    public var eventType, dateTime: String
    public var isApproximateTime: Bool
    public var height: Double
    public var isApproximateHeight, filtered: Bool
    public var date: String

    enum CodingKeys: String, CodingKey {
        case eventType = "EventType"
        case dateTime = "DateTime"
        case isApproximateTime = "IsApproximateTime"
        case height = "Height"
        case isApproximateHeight = "IsApproximateHeight"
        case filtered = "Filtered"
        case date = "Date"
    }

    public init(eventType: String, dateTime: String, isApproximateTime: Bool, height: Double, isApproximateHeight: Bool, filtered: Bool, date: String) {
        self.eventType = eventType
        self.dateTime = dateTime
        self.isApproximateTime = isApproximateTime
        self.height = height
        self.isApproximateHeight = isApproximateHeight
        self.filtered = filtered
        self.date = date
    }
    
}
