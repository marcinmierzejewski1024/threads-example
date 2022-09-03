//
//  BaseThread.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import Foundation

class IntervalThread: Thread {
    var logger : ((String) -> ())?
    
    var interval = TimeInterval(1.0)
    
    override func main() {
        while (!isCancelled) {
            repeatingTask()
            Thread.sleep(forTimeInterval: self.interval)
        }
    }
    
    func repeatingTask() {
    }
}
