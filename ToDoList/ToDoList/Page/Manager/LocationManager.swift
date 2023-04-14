//
//  LocationManager.swift
//  DoToList
//
//  Created by WEI-TSUNG CHENG on 2023/4/13.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    var currentLocation: CLLocation?
    
    var locationManager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    static let shared: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       
        switch status {
            case .authorizedAlways:
                print("location: authorizedAlways")
            case .authorizedWhenInUse:
                print("location: authorizedWhenInUse")
            case .denied:
                print("location: denied")
            case .notDetermined:
                print("location: notDetermined")
            case .restricted:
                print("location: restricted")
        @unknown default:
            print("location: unknown authorization")
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            
        print(error)
     }
}

