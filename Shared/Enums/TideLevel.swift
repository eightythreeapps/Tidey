//
//  TideLevel.swift
//  Tidey
//
//  Created by Ben Reed on 18/10/2023.
//

import Foundation

enum TideLevel {
    case high
    case low
    
    func iconName() -> String {
        switch self {
        case .high:
            return "arrow.up.circle.fill"
        case .low:
            return "arrow.down.circle.fill"
        }
    }
}
