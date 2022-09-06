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
    func count() -> Int
}


class SharedListServiceAbstract<T> : SharedListService {
    typealias SharedListServiceItem = T
    
    func append(item: SharedListServiceItem) {}
    func removeFirst(count: Int) -> [SharedListServiceItem]? { nil }
    func first(count: Int) -> [SharedListServiceItem]? { nil }
    func count() -> Int { 0 }
}

