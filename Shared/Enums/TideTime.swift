//
//  TideTime.swift
//  Tidey
//
//  Created by Ben Reed on 18/10/2023.
//

import Foundation

enum TideTime {
    
    case last
    case next
    
    func displayText() -> String {
        switch self {
        case .last:
            return "Last tide"
        case .next:
            return "Next tide"
        }
    }
    
}
