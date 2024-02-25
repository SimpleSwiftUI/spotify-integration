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
    @StateObject var viewModel: ViewModel
    @StateObject var spotifyController = SpotifyController()
    
    init() {
        let context = persistenceController.container.viewContext
        _viewModel = StateObject(wrappedValue: ViewModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(spotifyController)
                .onOpenURL { url in     // this is triggered when the app reopens after user authorizes in Spotify app
                    spotifyController.setAccessToken(from: url)
                }
        }
    }
}
