//
//  SpotifyView.swift
//  spotify-integration
//
//  Created by Robert Brennan on 2/25/24.
//

import SwiftUI

struct SpotifyView: View {
    @EnvironmentObject var spotifyController: SpotifyController
    
    let trackURI = "spotify:track:38i0QcGQ9hu8PMk4QObUTj"
    
    var body: some View {
        VStack {
            Button {
                spotifyController.connectAndPlayTrack(playURI: trackURI)
            } label: {
                Text("connectAndPlay()")
            }
            .padding()
            
            Button {
                spotifyController.pauseTrack()
            } label: {
                Text("pauseTrack()")
            }
            .padding()
        }
    }
}

//#Preview {
//    SpotifyView()
//}
