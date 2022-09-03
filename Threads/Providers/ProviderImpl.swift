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
    
    let urlSessionClient = URLSessionApiClient()
    
    func uploadString(_ string: String, url: URL) -> Error? {
        
        var error : Error?
        let waiter = DispatchGroup()
        let request = prepareRequest(url: url, content: string)
        
        waiter.enter()
        urlSessionClient.httpRequest(request) { data, potentialErr in
            error = potentialErr
            waiter.leave()
        }
        waiter.wait()
        
        return error
    }
    
    func uploadString(_ string: String, url: URL, completion: @escaping (Error?) -> ()) {
        let request = prepareRequest(url: url, content: string)
        urlSessionClient.httpRequest(request) { data, potentialErr in
            completion(potentialErr)
        }

    }
    
    func prepareRequest(url: URL, content: String) -> ApiRequest {
        let requestBody = ApiRequestBody(body: ["data":content])
        let request = ApiRequest.post(url: url.absoluteString, body: requestBody, headers: nil)
        
        return request
    }
}
