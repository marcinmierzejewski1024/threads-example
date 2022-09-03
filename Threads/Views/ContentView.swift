//
//  ContentView.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 02/09/2022.
//

import SwiftUI

struct ContentView: View {
    @State var threadViewModel = ThreadViewModel()
    var body: some View {
        VStack {
            Button("START") {
                threadViewModel.handleStart()
            }.padding()
            
            Button("STOP") {
                threadViewModel.handleStop()
            }.padding()

            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
