//
//  TideDataParser.swift
//  Tidey
//
//  Created by Ben Reed on 11/01/2024.
//

import Foundation
import GeoJSON

public class TideDataGeoJSONParser:TideDataParser {
    
    func parseFeatures(collection:FeatureCollection?) -> TideStations {
       
        if let features = collection?.features {
            var stations = TideStations()
            for feature in features {
                let tideStation = TideStation(feature: feature)
                stations.append(tideStation)
            }
            
            return stations
        }
        
        return TideStations()
        
    }
    
    func parseFeature(feature:Feature) -> TideStation {
        return TideStation(feature: feature)
    }
    
    func parseEvents(events:[Event]) -> TidalEvents {
        
        var tidalEvents = TidalEvents()
        
        for event in events {
            let tidalEvent = TidalEvent(event: event)
            tidalEvents.append(tidalEvent)
        }
        
        return tidalEvents
    }
    
}
