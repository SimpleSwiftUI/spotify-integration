//
//  SpotifyController.swift
//  spotify-integration
//
//  Created by Robert Brennan on 2/25/24.
//

import SpotifyiOS
import Combine

// Credit: https://github.com/tillhainbach/SpotifyQuickStart/blob/main/SpotifyQuickStart/SpotifyController.swift

class SpotifyController: NSObject, ObservableObject, SPTAppRemotePlayerStateDelegate, SPTAppRemoteDelegate {
    let spotifyClientID = "abc123abc123abc123abc123abc12345"
    let spotifyRedirectURL = URL(string: "spotify-integration://spotify-login-callback")!
    var accessToken: String? = nil
    
    private var executingPause = false
    private var executingGetPlayerState = false
    private var reconnectRequired = false
    private var connectCancellable: AnyCancellable?
    private var disconnectCancellable: AnyCancellable?
    
    override init() {
        super.init()
        
        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // code here will run automatically when app come to foreground (e.g. app is launched)
            }
        
        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // code here will run automatically when app goes to background (e.g. use swipes up to open app switcher)
            }
    }
    
    lazy var configuration = SPTConfiguration(clientID: spotifyClientID, redirectURL: spotifyRedirectURL)
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    func connectAndPlayTrack(playURI: String) {
        guard let _ = self.appRemote.connectionParameters.accessToken else {
            print("connectAndPlayTrack: no access token. Authorizing, getting token, and playing...")
            self.appRemote.authorizeAndPlayURI(playURI)
            return
        }
        
        if self.reconnectRequired {
            print("connectAndPlayTrack: reconnectRequired")
            self.reconnectRequired = false
            self.appRemote.authorizeAndPlayURI(playURI)
            return
        }
        
        print("connectAndPlayTrack: calling appRemote.connect...")
        self.appRemote.connect()
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("appRemoteDidEstablishConnection...")
        self.appRemote = appRemote
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        
        if self.executingPause {
            print("delegate executing pause...")
            self.executingPause = false
            executePause()
        } else if self.executingGetPlayerState {
            print("delegate executing getplayerstate...")
            self.executingGetPlayerState = false
            executeGetPlayerState()
        }
    }
    
    func pauseTrack() {
        self.executingPause = true
        if appRemote.isConnected {
            print("pauseTrack: appRemote is connected. Executing pause...")
            executePause()
        } else {
            print("pauseTrack: appRemote not connected. Calling connectAndPause...")
            connectAndPause()
        }
    }
    
    private func connectAndPause() {
        print("connectandpause()...")
        guard let _ = self.appRemote.connectionParameters.accessToken else {
            print("connectAndPause(): no access token available")
            return
        }
        
        appRemote.connect()
    }
    
    private func executePause() {
        print("executePause()...")
        appRemote.playerAPI?.pause { (result, error) in
            if let error = error {
                print("executePause() error: \(error.localizedDescription)")
            } else {
                print("Song paused successfully.")
            }
        }
    }
    
    func getPlayerState() {
        self.executingGetPlayerState = true
        if appRemote.isConnected {
            print("getPlayerState: appRemote is connected. Executing getPlayerState...")
            executeGetPlayerState()
        } else {
            print("getPlayerState: appRemote not connected. Calling connectAndGetPlayerState...")
            connectAndGetPlayerState()
        }
    }
    
    private func connectAndGetPlayerState() {
        print("connectAndGetPlayerState()")
        guard let _ = self.appRemote.connectionParameters.accessToken else {
            print("connectAndGetPlayerState: no access token")
            return
        }
        
        appRemote.connect()
    }
    
    private func executeGetPlayerState() {
        print("executeGetPlayerState...")
        appRemote.playerAPI?.getPlayerState { (result, error) in
            if let error = error {
                print("executeGetPlayerState error: \(error.localizedDescription)")
            } else {
                print("executeGetPlayerState successful.")
            }
        }
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("printStateDidChange triggered")
        print("\(playerState.track.name): isPlaying: \(playerState.isPaused ? "No" : "Yes")")
        print("\(playerState.track.name): timestamp: \(playerState.playbackPosition / 1000)")   // playbackPosition is in milliseconds
        // logPlayerState(playerState)
    }
    
    // Helper function to log details of the player state
    private func logPlayerState(_ playerState: SPTAppRemotePlayerState) {
        print("\n--- Player State Details ---")
        print("Track name: \(playerState.track.name)")
        print("Artist name: \(playerState.track.artist.name)")
        print("Album name: \(playerState.track.album.name)")
        print("Playback position: \(playerState.playbackPosition) ms")
        print("Is playing: \(playerState.isPaused ? "No" : "Yes")")
        print("Track URI: \(playerState.track.uri)")
        print("--------------------------------\n")
    }
    
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print(errorDescription)
        }
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("appRemote: didFailConnectionAttemptWithError. error: \(error?.localizedDescription ?? "")")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        self.reconnectRequired = true
        print("appRemote: disconnectedWithError. error \(error?.localizedDescription ?? "")")
    }
    
    func disconnect() {
        if appRemote.isConnected {
            print("Disconnecting appRemote...")
            appRemote.disconnect()
        }
    }
}
