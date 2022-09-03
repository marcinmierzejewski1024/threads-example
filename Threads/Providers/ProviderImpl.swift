//
//  ProviderImpl.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import Foundation
import UIKit
import CoreLocation

class BatteryInfoProviderImpl : BatteryInfoProvider {
    
    func getBatteryPercentage() -> Float {
        return UIDevice.current.batteryLevel
    }
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
}

class LocationInfoProviderImpl : NSObject, LocationInfoProvider, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var lastLatLng : (Double, Double)?
    
    func getLatLng() -> (Double, Double)? {
        return lastLatLng
    }
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            lastLatLng = (lastLocation.coordinate.latitude,lastLocation.coordinate.longitude)
        }
    }
}

class LogUploaderImpl : LogUploader {
    func uploadString(_ string: String) -> Error? {
        return nil;
    }
    
    func uploadString(_ string: String, completion: @escaping (Error?) -> ()) {
        completion(nil)
    }
}
