//
//  ContentView.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var threadViewModel = ThreadViewModel()
    var body: some View {
        VStack {
            HStack {
            Button("Start") {
                threadViewModel.startClicked()
            }.padding()
            
            Button("Stop") {
                threadViewModel.stopClicked()
            }.padding()
                
            Button("Debug") {
                threadViewModel.debugClicked()
            }.padding()
            }
            ConsoleView(content: threadViewModel.consoleLog)
            

            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
