//
//  ViewModel.swift
//  spotify-integration
//
//  Created by Robert Brennan on 2/25/24.
//

import Foundation
import CoreData



// MONDAY: test on device, remvoe clientID, deploy



// SPOTIFY DEVELOPER APP SETUP
//
// You need to register for a Spotify Developer account register your app.
// https://developer.spotify.com/dashboard
//
// Follow these steps:
// Create App
// Enter App Name, description, website
// Redirect URI: this must match what you put in the query URL (see below);
// e.g. myapp.myorganization.apps.spotify-integration
// Select iOS (and any others you intend to use)
// Accept Terms of Service
// Save.
//
// When the app dashboard appears, copy the Client ID and paste it in
// spotifyClientID in SpotifyController.swift.
// Copy your RedirectURI and paste it in spotifyRedirectURL in SpotifyController.swift.
//

//
// PERMISSIONS
//
// To check if Spotify is installed, and to launch the Spotify app, you need permission.
// In XCode > Click <project name> at the top of the Project Navigator (left panel) >
// Click <project name> under Targets > Click "Info" tab > Under "Custom iOS Target Properties",
// right-click and choose "Raw Keys and Values". Hover mouse on a row item and click the (+) icon >
// In the new row, type: "LSApplicationQueriesSchemes" > Hit Enter. Click the small arrow to
// expand the array. In the Value column for Item 0, enter "spotify" (no quotes).
//
// To enable music streaming/ you also need to:
// In a new row, type: "NSAppTransportSecurity" > Hit Enter. Click the small arrow to
// expand the array. In the dropdown, choose "NSAllowsArbitaryLoads". In the Value column,
// use the dropdown to change to YES.
//
// QUERY URL
//
// You also need to add a query URL representing your app to the iOS system. This registers
// myapp:// to the system so other apps (i.e. Spotify) can re-open your app. In the same "Info"
// tab as above, expand "URL Types" at the bottom. Add a new entry.
// - Identifer: your app bundle identifier (you can copy this from the Signing & Capabilites tab)
// - URL Schemes: "myapp"
// - Icon: [blank]
// - Role: [Editor] (doesn't matter for this purpose)
// Now, when Spotify calls myapp://spotify-login-callback, it will open your app.
//



class ViewModel: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
}
