//
//  Loadable.swift
//  Tidey
//
//  Created by Ben Reed on 26/04/2023.
//

import Foundation

enum LoadingState {
    case notLoading
    case loading
    case loaded
    case error
}

protocol Loadable {
    var state:LoadingState { get set }
    func loadData()
}
