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
                packagesToSend.append(potentialPackage)
            }
            
            self.uploadNextPackage()

            Thread.sleep(forTimeInterval: self.interval)
        }
    }
    
    
    func uploadNextPackage(){

        if let nextPackage = packagesToSend.first {
            switch mode {
            case .async:
                uploader?.uploadString(nextPackage, completion: { [self] err in
                    if let err = err {
                         print("Error while uploading package \(nextPackage) err:\(err)")
                    } else {
                        self.packagesToSend.removeFirst()
                    }
                })
            case .sync:
                let err = uploader?.uploadString(nextPackage)
                if let err = err {
                    print("Error while uploading package \(nextPackage) err:\(err)")
                } else {
                    packagesToSend.removeFirst()
                }
                
            }
        }
    }
}
