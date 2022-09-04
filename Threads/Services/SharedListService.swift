//
//  SharedListService.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 04/09/2022.
//

import Foundation

typealias SharedListServiceItem = String
protocol SharedListService {
    func append(item: SharedListServiceItem)
    func removeFirst(count: Int) -> [SharedListServiceItem]?
    func first(count: Int) -> [SharedListServiceItem]?
    func count() -> Int
}


