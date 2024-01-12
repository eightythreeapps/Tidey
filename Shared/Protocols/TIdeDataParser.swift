//
//  TideDataParser.swift
//  Tidey
//
//  Created by Ben Reed on 11/01/2024.
//

import Foundation
import GeoJSON

protocol TideDataParser {
    func parseFeatures(collection:FeatureCollection?) -> TideStations
    func parseFeature(feature:Feature) -> TideStation
    func parseEvents(events:[Event]) -> TidalEvents
}
