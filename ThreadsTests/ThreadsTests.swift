//
//  ThreadsTests.swift
//  ThreadsTests
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import XCTest
@testable import Threads

class ThreadsTests: XCTestCase {

    
    func testSend() throws {
        
        let sut = ThreadViewModel()
        sut.configurator = ThreadViewModelMockConfiguratorImpl()
        
        sut.prepareThreads(t1Interval: 0.4, t2Interval: 0.2, queueSize: 11, url: "http://wp.pl")
        sut.start()
        
        
    }


}
