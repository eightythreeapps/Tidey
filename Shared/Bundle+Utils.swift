//
//  Bundle+Utils.swift
//  WristTide Watch App
//
//  Created by Ben Reed on 12/04/2023.
//

import Foundation

enum BundleKey:String {
    case tideGuageBaseUrl = "TideApiBaseURL"
    case ukTidalApiBaseUrl = "UKTidalAPIBaseURL"
}

extension Bundle {
    
    func object(key:BundleKey) -> String {
        
        return self.object(forInfoDictionaryKey: key.rawValue) as! String
        
    }
    
}
