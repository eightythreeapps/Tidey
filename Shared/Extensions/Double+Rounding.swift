//
//  Double+Rounding.swift
//  Tidey
//
//  Created by Ben Reed on 12/01/2024.
//

import Foundation

extension Double {
    
    //Based on https://stackoverflow.com/questions/34929932/round-up-double-to-2-decimal-places
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
