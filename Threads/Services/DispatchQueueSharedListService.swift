//
//  DispatchQueueSharedListService.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 05/09/2022.
//

import Foundation


class DispatchQueueSharedListService<SharedListServiceItem> : SharedListService<SharedListServiceItem> {
    private let accessQueue = DispatchQueue(label: "DispatchQueueSharedListService")
    var sharedList = [SharedListServiceItem]()

    override func append(item: SharedListServiceItem) {
        accessQueue.async {
            self.sharedList.append(item)
        }
    }
    
    override func removeFirst(count: Int) -> [SharedListServiceItem]? {
        
        var result: [SharedListServiceItem]?
        accessQueue.sync {
            result = Array(sharedList.prefix(count))
            sharedList.removeFirst(count)
        }
        return result
    }
    
    override func first(count: Int) -> [SharedListServiceItem]? {
        var result: [SharedListServiceItem]?
        accessQueue.sync {
            result = Array(sharedList.prefix(count))
        }
        return result
    }
    
    override func count() -> Int {
        var result = 0
        accessQueue.sync {
            result = sharedList.count
        }
        return result
    }
    

}
