//
//  Bundle+Utils.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import Foundation

extension Bundle {
    
    func object(key:ConfigurationKey) -> String {
        
        return self.object(forInfoDictionaryKey: key.rawValue) as! String
        
    }
    
}
