//
//  FileHelper.swift
//  Tidey
//
//  Created by Ben Reed on 11/01/2024.
//

import Foundation

class FileHelper {
    
    enum PreviewFile:String {
        case tideStations = "UKTideStations"
        case station = "UKTideStation"
        case tidalEvents = "TideEvents"
        case tideStationsBad = "UKTideStationsBadData"
    }
        
    static func loadLocalJSON(fileType:PreviewFile) -> Data {
        let stations = Bundle.main.path(forResource: fileType.rawValue, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: stations), options: .mappedIfSafe)
        return data
    }
    
}

