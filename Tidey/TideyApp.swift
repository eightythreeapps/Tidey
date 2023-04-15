//
//  TideyApp.swift
//  Tidey
//
//  Created by Ben Reed on 14/04/2023.
//

import SwiftUI

@main
struct TideyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
           ContentView()
        }
    }
}
