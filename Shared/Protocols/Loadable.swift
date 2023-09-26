//
//  Loadable.swift
//  Tidey
//
//  Created by Ben Reed on 26/04/2023.
//

import Foundation

enum ApplicationState {
    case notConfigured
    case configured(apiKey:String)
}

enum LoadingState {
    case idle
    case loading
    case loaded
    case error
}

protocol Loadable {
    var state:LoadingState { get set }
    func loadData()
}
