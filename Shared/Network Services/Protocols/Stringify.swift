//
//  Stringify.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import Foundation

protocol Stringify {
    func stringValue() -> String
}

extension Stringify where Self: RawRepresentable  {
    internal func stringValue() -> String {
        return self.rawValue as! String
    }
}
