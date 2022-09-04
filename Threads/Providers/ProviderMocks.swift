//
//  ProviderMocks.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import Foundation

class BatteryMockProviderImpl : BatteryInfoProvider {
    func getBatteryPercentage() -> Float {
        return 0.77
    }
    
}

class LocationMockProviderImpl : LocationInfoProvider {
    func getLatLng() -> (Double, Double)? {
        return (51.3340, 20.5589)
    }
    func authorized() -> Bool {
        return true
    }
    
}

class LogUploaderMockImpl : LogUploader {
    var uploaded = [String]()
    
    func uploadString(_ string: String, url: URL) -> Error? {
        print("uploaded \(string)")
        uploaded.append(string)
        return nil;
    }
    
    func uploadString(_ string: String, url: URL, completion: @escaping (Error?) -> ()) {
        print("uploaded \(string)")
        self.uploaded.append(string)
        completion(nil)
    }
}


class ThreadViewModelMockConfiguratorImpl : ThreadViewModelConfigurator {
    func prepareThreads(t1Interval: TimeInterval, t2Interval: TimeInterval, queueSize: Int, url: String) -> (T1, T2, T3) {
        
        let sharedListService = SemaphoreSharedListService()
        let packagesQueueService = SemaphoreSharedListService()

        
        let t1 = T1()
        t1.interval = t1Interval
        t1.batteryProvider = BatteryMockProviderImpl()
        t1.sharedListService = sharedListService
        
        let t2 = T2()
        t2.interval = t2Interval
        t2.locationProvider = LocationMockProviderImpl()
        t2.sharedListService = sharedListService

        
        let t3 = T3()
        t3.queueSize = queueSize
        t3.url = URL(string: url)
        t3.interval = min(t1Interval, t2Interval) * 0.1
        t3.uploader = LogUploaderMockImpl()
        t3.sharedListService = sharedListService
        t3.packagesQueueService = packagesQueueService

        
        return (t1,t2,t3)
    }
    
    
}
