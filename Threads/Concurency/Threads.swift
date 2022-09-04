//
//  Threads.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 03/09/2022.
//

import Foundation


class T1 : IntervalThread {
    var batteryProvider: BatteryInfoProvider?
    var sharedListService: SharedListService?

    override func repeatingTask() {
        if let val = batteryProvider?.getBatteryPercentage() {
            sharedListService?.append(item: "\(val)")
        }
    }
}

class T2 : IntervalThread {
    var locationProvider: LocationInfoProvider?
    var sharedListService: SharedListService?

    override func repeatingTask() {
        if let val = locationProvider?.getLatLng() {
            sharedListService?.append(item: "\(val)")
        }
    }
    
}

class T3 : IntervalThread {
    enum UploadMode {
        case async
        case sync
    }
    
    var uploader : LogUploader?
    var url : URL?
    var queueSize = 1
    var mode = UploadMode.async
    var sharedListService: SharedListService?
    var packagesQueueService: SharedListService?
    
    override func repeatingTask() {
        
        guard let sharedListService = sharedListService else {
            logger?("mising sharedListService")
            return
        }
        guard let packagesQueueService = packagesQueueService else {
            logger?("mising packagesQueueService")
            return
        }

        
        var potentialPackage: String?
        
        if (sharedListService.count() >= queueSize) {
            let items = sharedListService.removeFirst(count: queueSize)
            potentialPackage = items?.joined(separator: ",")
        }
        
        if let potentialPackage = potentialPackage {
            packagesQueueService.append(item: potentialPackage)
            uploadNextPackage()
        }
    }
    
    
    func uploadNextPackage() {
        guard let url = url else {
            logger?("missing url!")
            return
        }
        
        let nextPackage = packagesQueueService?.first(count: 1)?.first
        
        logger?("packages to send start \(self.packagesQueueService?.count() ?? -1)")
        
        if let nextPackage = nextPackage {
            switch mode {
                
            case .async:
                uploader?.uploadString(nextPackage, url: url, completion: { [weak self] err in
                    if let err = err {
                        self?.logger?("Error while uploading package \(nextPackage) err:\(err)")
                    } else {
                        let _ = self?.packagesQueueService?.removeFirst(count: 1)
                        self?.logger?("packages To Send after \(self?.packagesQueueService?.count() ?? -1)")
                    }
                })
                
            case .sync:
                let err = uploader?.uploadString(nextPackage, url: url)
                if let err = err {
                    logger?("Error while uploading package \(nextPackage) err:\(err)")
                } else {
                    let _ = packagesQueueService?.removeFirst(count: 1)
                }
                logger?("packages To Send after \(packagesQueueService?.count() ?? -1)")
            }
        }
    }
}
