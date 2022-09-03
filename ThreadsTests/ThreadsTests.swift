//
//  ThreadsTests.swift
//  ThreadsTests
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import XCTest
@testable import Threads


class ThreadsTests: XCTestCase {
    
    func testPackaging() throws {
        
        let sut = ThreadViewModel()
        sut.configurator = ThreadViewModelMockConfiguratorImpl()
        sut.prepareThreads(t1Interval: 0.01, t2Interval: 0.01, queueSize: 10, url: "http://wp.pl")
        sut.t3?.mode = .sync
        sut.start()

        let waiter = DispatchGroup()
        waiter.enter()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            waiter.leave()
        }
        waiter.wait()
        
        if let mockUploader = sut.t3?.uploader as? LogUploaderMockImpl {
            print(mockUploader.uploaded.count)
            XCTAssert(mockUploader.uploaded.count >= 10)
        }
    }
}



