//
//  ThreadsApp.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import SwiftUI
import DBDebugToolkit

@main
struct ThreadsApp: App {
    
    init(){
        let shakeTrigger = DBShakeTrigger()
        DBDebugToolkit.setup(with: [shakeTrigger])
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
