//
//  Threads.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 03/09/2022.
//

import Foundation


class T1 : IntervalThread {
    var batteryProvider: BatteryInfoProvider?
    
    override func repeatingTask() {
        ThreadViewModel.sharedListSemaphore.wait()
        if let val = batteryProvider?.getBatteryPercentage() {
            ThreadViewModel.sharedList.append("\(val)")
        }
        ThreadViewModel.sharedListSemaphore.signal()
    }
}

class T2 : IntervalThread {
    var locationProvider: LocationInfoProvider?
    
    override func repeatingTask() {
        ThreadViewModel.sharedListSemaphore.wait()
        if let val = locationProvider?.getLatLng() {
            ThreadViewModel.sharedList.append("\(val)")
        }
        ThreadViewModel.sharedListSemaphore.signal()
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
    
    private var packagesToSend = [String]()
    private let packagesToSendSemaphore = DispatchSemaphore(value: 1)
    
    override func repeatingTask() {
        
        var potentialPackage: String?
        
        ThreadViewModel.sharedListSemaphore.wait()
        if (ThreadViewModel.sharedList.count >= queueSize) {
            let items = ThreadViewModel.sharedList.prefix(queueSize)
            ThreadViewModel.sharedList.removeFirst(queueSize)
            potentialPackage = items.joined(separator: ",")
        }
        ThreadViewModel.sharedListSemaphore.signal()
        
        
        if let potentialPackage = potentialPackage {
            packagesToSendSemaphore.wait()
            packagesToSend.append(potentialPackage)
            packagesToSendSemaphore.signal()
            
            uploadNextPackage()
        }
    }
    
    
    func uploadNextPackage() {
        guard let url = url else {
            logger?("missing url!")
            return
        }
        
        self.packagesToSendSemaphore.wait()
        let nextPackage = packagesToSend.first
        self.packagesToSendSemaphore.signal()
        
        logger?("packages to send start \(self.packagesToSend.count)")
        
        if let nextPackage = nextPackage {
            switch mode {
                
            case .async:
                uploader?.uploadString(nextPackage, url: url, completion: { [weak self] err in
                    if let err = err {
                        self?.logger?("Error while uploading package \(nextPackage) err:\(err)")
                    } else {
                        self?.packagesToSendSemaphore.wait()
                        self?.packagesToSend.removeFirst()
                        self?.packagesToSendSemaphore.signal()
                        self?.logger?("packages To Send after \(self?.packagesToSend.count ?? -1)")
                    }
                })
                
            case .sync:
                let err = uploader?.uploadString(nextPackage, url: url)
                if let err = err {
                    logger?("Error while uploading package \(nextPackage) err:\(err)")
                } else {
                    packagesToSend.removeFirst()//same thread - no need to synchronize access
                }
                logger?("packages To Send after \(self.packagesToSend.count)")
            }
        }
    }
}
