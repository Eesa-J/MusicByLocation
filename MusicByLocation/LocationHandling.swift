//
//  LocationHandling.swift
//  MusicByLocation
//
//  Created by Jaswal, Eesa (SPH) on 03/03/2023.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    @Published var lastKnownCountry: String = ""
    @Published var lastKnownLocation: String = ""
    @Published var lastKnownStreet: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first {
            geocoder.reverseGeocodeLocation(firstLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    self.lastKnownLocation = "Could not perform lookup of location from coordinate information"
                } else {
                    if let firstPlacemark = placemarks?[0] {
                        self.lastKnownCountry = firstPlacemark.country ?? "Could not find country"
                        self.lastKnownLocation = firstPlacemark.locality ?? "Could not find locality"
                        self.lastKnownStreet = firstPlacemark.thoroughfare ?? "Could not find street"
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lastKnownCountry = "Error finding country"
        lastKnownLocation = "Error finding location"
        lastKnownStreet = "Error finding street"
    }
    
    func displayLocation() -> String {
        let location = """
                        Country: \(self.lastKnownCountry)
                        City: \(self.lastKnownLocation)
                        Street: \(self.lastKnownStreet)
                        """
        return location
    }
}
