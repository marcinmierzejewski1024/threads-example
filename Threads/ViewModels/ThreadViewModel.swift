//
//  ThreadViewModel.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import Foundation

class ThreadViewModel {
    
    static let sharedListSemaphore = DispatchSemaphore(value: 1)
    static var sharedList = [String]()
//    static var sharedListFilledSemaphore : DispatchSemaphore?
    
    var configurator: ThreadViewModelConfigurator = ThreadViewModelConfiguratorImpl()
    var t1 : T1?
    var t2 : T2?
    var t3 : T3?
    
    func handleStart() {
        let a = 0.02
        let b = 0.01
        let c = 40
        let d = "http://wp.pl"
        
        prepareThreads(t1Interval: a, t2Interval: b, queueSize: c, url: d)
        start()
    }
    
    
    func prepareThreads(t1Interval:TimeInterval, t2Interval:TimeInterval, queueSize:Int, url: String) {
        
        guard t1 == nil else {
            print("already prepared")
            return
        }
//        ThreadViewModel.sharedListFilledSemaphore = DispatchSemaphore(value: -queueSize)
//        #warning("mock configurator")
//        self.configurator = ThreadViewModelMockConfiguratorImpl()
        
        (self.t1, self.t2, self.t3) = self.configurator.prepareThreads(t1Interval: t1Interval, t2Interval: t2Interval, queueSize: queueSize, url: url)
        
    }
    
    func start() {
        guard !(t1?.isExecuting ?? true) else {
            print("already started")
            return
        }
        
        t1?.start()
        t2?.start()
        t3?.start()
    }
    
    
    func handleStop() {
        t1?.cancel()
        t2?.cancel()
        t3?.cancel()
        
        t1 = nil
        t2 = nil
        t3 = nil
    }
}

class ThreadViewModelConfiguratorImpl : ThreadViewModelConfigurator {
    
    func prepareThreads(t1Interval:TimeInterval, t2Interval:TimeInterval, queueSize:Int, url: String) -> (T1, T2, T3) {
        let t1 = T1()
        t1.interval = t1Interval
        t1.batteryProvider = BatteryInfoProviderImpl()
        
        let t2 = T2()
        t2.interval = t2Interval
        t2.locationProvider = LocationInfoProviderImpl()
        
        let t3 = T3()
        t3.queueSize = queueSize
        t3.url = URL(string: url)
        t3.interval = min(t1Interval, t2Interval) * 0.1
        t3.uploader = LogUploaderImpl()
        
        return (t1,t2,t3)
    }
}
