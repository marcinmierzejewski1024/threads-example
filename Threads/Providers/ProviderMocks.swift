//
//  ProviderMocks.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import Foundation

class BatteryMockProviderImpl : BatteryInfoProvider {
    func getBatteryPercentage() -> Float {
        return 77.4

    }
    
}

class LocationMockProviderImpl : LocationInfoProvider {
    func getLatLng() -> (Double, Double)? {
        return (51.3340, 20.5589)
    }
    
}

class LogUploaderMockImpl : LogUploader {
    var uploaded = [String]()
    
    func uploadString(_ string: String) -> Error? {
        Thread.sleep(forTimeInterval: 0.2)
        print("uploaded \(string)")
        uploaded.append(string)
        return nil;
    }
    
    func uploadString(_ string: String, completion: @escaping (Error?) -> ()) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            print("uploaded \(string)")
            self.uploaded.append(string)
            completion(nil)

        }
    }
}


class ThreadViewModelMockConfiguratorImpl : ThreadViewModelConfigurator {
    func prepareThreads(t1Interval: TimeInterval, t2Interval: TimeInterval, queueSize: Int, url: String) -> (T1, T2, T3) {
        
        let t1 = T1()
        t1.interval = t1Interval
        t1.batteryProvider = BatteryMockProviderImpl()
        
        let t2 = T2()
        t2.interval = t2Interval
        t2.locationProvider = LocationMockProviderImpl()
        
        let t3 = T3()
        t3.queueSize = queueSize
        t3.url = url
        t3.interval = min(t1Interval, t2Interval) * 0.1
        t3.uploader = LogUploaderMockImpl()
        
        return (t1,t2,t3)
    }
    
    
}
