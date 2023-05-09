//
//  LocationDataProvider.swift
//  Tidey
//
//  Created by Ben Reed on 09/05/2023.
//

import Foundation
import CoreLocation

public protocol LocationDataProvider {
    func getState() async -> AsyncStream<LocationProviderState>
}
