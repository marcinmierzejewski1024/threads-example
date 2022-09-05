//
//  DispatchQueueSharedListService.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 05/09/2022.
//

import Foundation


class DispatchQueueSharedListService : SharedListService {
    private let accessQueue = DispatchQueue(label: "DispatchQueueSharedListService")
    var sharedList = [SharedListServiceItem]()

    func append(item: SharedListServiceItem) {
        accessQueue.async {
            self.sharedList.append(item)
        }
    }
    
    func removeFirst(count: Int) -> [SharedListServiceItem]? {
        
        var result: [SharedListServiceItem]?
        accessQueue.sync {
            result = Array(sharedList.prefix(count))
            sharedList.removeFirst(count)
        }
        return result
    }
    
    func first(count: Int) -> [SharedListServiceItem]? {
        var result: [SharedListServiceItem]?
        accessQueue.sync {
            result = Array(sharedList.prefix(count))
        }
        return result
    }
    
    func count() -> Int {
        var result = 0
        accessQueue.sync {
            result = sharedList.count
        }
        return result
    }
    

}
