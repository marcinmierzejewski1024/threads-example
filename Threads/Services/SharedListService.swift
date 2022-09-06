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


class SharedListServiceAbstract<T> : SharedListService {
    var count: Int {
        0
    }
    
    typealias SharedListServiceItem = T
    
    func append(item: SharedListServiceItem) {}
    func removeFirst(count: Int) -> [SharedListServiceItem]? { nil }
    func first(count: Int) -> [SharedListServiceItem]? { nil }
}

