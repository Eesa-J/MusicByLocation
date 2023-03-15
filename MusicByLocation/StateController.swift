//
//  StateController.swift
//  MusicByLocation
//
//  Created by Jaswal, Eesa (SPH) on 04/03/2023.
//

import Foundation

class StateController: ObservableObject {
    
    let locationHandler: LocationHandler = LocationHandler()
    let iTunesAdapter = ITunesAdapter()
    @Published var artistsByLocation: [String] = [""]
    
    var lastKnownLocation: String = "" {
        didSet {
            iTunesAdapter.getArtists(search: lastKnownLocation, completion: updateArtistsByLocation)
        }
    }
    
    func findMusic() {
        locationHandler.requestLocation()
    }
    
    func requestAccessToLocationData() {
        locationHandler.stateController = self
        locationHandler.requestAuthorisation()
    }
    
    func updateArtistsByLocation(artists: [Artist]?) {
        let names = artists?.map { return $0.name }
        DispatchQueue.main.async {
            self.artistsByLocation = names ?? ["Error finding artists from your location"]
        }
    }
    
}
