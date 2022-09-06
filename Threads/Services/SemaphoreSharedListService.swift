//
//  SemaphoreSharedListService.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 04/09/2022.
//

import Foundation

class SemaphoreSharedListService<SharedListServiceItem> : SharedListServiceAbstract<SharedListServiceItem> {
    
    let sharedListSemaphore = DispatchSemaphore(value: 1)
    var sharedList = [SharedListServiceItem]()
    
    override func append(item: SharedListServiceItem) {
        self.sharedListSemaphore.wait()
        self.sharedList.append(item)
        self.sharedListSemaphore.signal()
    }
    
    override func first(count: Int) -> [SharedListServiceItem]? {
        self.sharedListSemaphore.wait()
        defer {
            self.sharedListSemaphore.signal()
        }
        return Array(sharedList.prefix(count))
    }

    
    override func removeFirst(count: Int) -> [SharedListServiceItem]? {
        self.sharedListSemaphore.wait()
        defer {
            self.sharedListSemaphore.signal()
        }
        if(sharedList.count >= count) {
            let result = Array(sharedList.prefix(count))
            self.sharedList.removeFirst(count)
            return result
        }
        return nil
    }
    
    override var count: Int {
        self.sharedListSemaphore.wait()
        defer {
            self.sharedListSemaphore.signal()
        }
        return sharedList.count
    }
    
}
