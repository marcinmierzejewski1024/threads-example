//
//  SharedListService.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 04/09/2022.
//

import Foundation


protocol SharedListService {
    associatedtype SharedListServiceItem
    
    func append(item: SharedListServiceItem)
    func removeFirst(count: Int) -> [SharedListServiceItem]?
    func first(count: Int) -> [SharedListServiceItem]?
    var count: Int { get }
}

//type erasure
class AnySharedListService<T> : SharedListService {
    
    typealias SharedListServiceItem = T
    
    func append(item: SharedListServiceItem) {}
    func removeFirst(count: Int) -> [SharedListServiceItem]? { nil }
    func first(count: Int) -> [SharedListServiceItem]? { nil }
    var count: Int {
        0
    }
    
}

