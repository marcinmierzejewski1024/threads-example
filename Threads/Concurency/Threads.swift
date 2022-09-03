//
//  Threads.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 03/09/2022.
//

import Foundation


class T1 : IntervalThread {
    var batteryProvider: BatteryInfoProvider?
    
    override func main() {
        while (!isCancelled) {
            ThreadViewModel.sharedListSemaphore.wait()
            if let val = batteryProvider?.getBatteryPercentage() {
                ThreadViewModel.sharedList.append("\(val)")
            }
            ThreadViewModel.sharedListSemaphore.signal()
            
            Thread.sleep(forTimeInterval: self.interval)
            
        }
    }
}

class T2 : IntervalThread {
    var locationProvider: LocationInfoProvider?
    
    override func main() {
        while (!isCancelled) {
            ThreadViewModel.sharedListSemaphore.wait()
            if let val = locationProvider?.getLatLng() {
                ThreadViewModel.sharedList.append("\(val)")
            }
            ThreadViewModel.sharedListSemaphore.signal()
            
            Thread.sleep(forTimeInterval: self.interval)
            
        }
    }
}

class T3 : IntervalThread {
    enum UploadMode {
        case async
        case sync
    }
    
    var mode = UploadMode.sync
    var uploader : LogUploader?
    var url : String?
    var queueSize = 1
    
    private var packagesToSend = [String]()
    private let packagesToSendSemaphore = DispatchSemaphore(value: 1)
    
    override func main() {
        while (!isCancelled) {
            
            var potentialPackage :String?
            
            ThreadViewModel.sharedListSemaphore.wait()
            if (ThreadViewModel.sharedList.count >= queueSize) {
                let items = ThreadViewModel.sharedList.dropFirst(queueSize)
                potentialPackage = items.joined(separator: ",")
            }
            ThreadViewModel.sharedListSemaphore.signal()
            
            
            if let potentialPackage = potentialPackage {
                self.packagesToSendSemaphore.wait()
                packagesToSend.append(potentialPackage)
                self.packagesToSendSemaphore.signal()

            }
            
            self.uploadNextPackage()

            Thread.sleep(forTimeInterval: self.interval)
        }
    }
    
    
    func uploadNextPackage(){

        self.packagesToSendSemaphore.wait()
        let nextPackage = packagesToSend.first
        self.packagesToSendSemaphore.signal()

        print("packagesToSend start \(self.packagesToSend.count)")

        if let nextPackage = nextPackage {
            switch mode {
            case .async:
                uploader?.uploadString(nextPackage, completion: { [weak self] err in
                    if let err = err {
                         print("Error while uploading package \(nextPackage) err:\(err)")
                    } else {
                        self?.packagesToSendSemaphore.wait()
                        self?.packagesToSend.removeFirst()
                        self?.packagesToSendSemaphore.signal()
                        print("packagesToSend after \(self?.packagesToSend.count ?? -1)")
                    }
                })
            case .sync:
                let err = uploader?.uploadString(nextPackage)
                if let err = err {
                    print("Error while uploading package \(nextPackage) err:\(err)")
                } else {
                    packagesToSend.removeFirst()//same thread - no need to synchronize access
                }
                print("packagesToSend after \(self.packagesToSend.count)")
            }
        }
    }
}
