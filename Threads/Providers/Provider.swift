//
//  Provider.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import Foundation

protocol BatteryInfoProvider {
    func getBatteryPercentage()->Float
}

protocol LocationInfoProvider {
    func getLatLng() -> (Double,Double)?
    func authorized() -> Bool
}

protocol LogUploaderSync {
    func uploadString(_ string: String, url: URL) -> Error?
}

protocol LogUploaderAsync {
    func uploadString(_ string: String, url: URL, completion :@escaping (Error?)->())
}

typealias LogUploader = LogUploaderSync & LogUploaderAsync

protocol ThreadViewModelConfigurator {
    func prepareThreads(t1Interval:TimeInterval, t2Interval:TimeInterval, queueSize:Int, url: String) -> (T1,T2,T3)

}
