//
//  spotify_integrationApp.swift
//  spotify-integration
//
//  Created by Robert Brennan on 2/25/24.
//

import SwiftUI

@main
struct spotify_integrationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
