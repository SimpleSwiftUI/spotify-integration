//
//  ContentView.swift
//  spotify-integration
//
//  Created by Robert Brennan on 2/25/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            NavigationLink {
                SpotifyView()
            } label: {
                Text("Open Spotify View")
            }
            .padding()
        }
    }
}


//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
