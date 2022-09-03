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
                threadViewModel.startClicked()
            }.padding()
            
            Button("STOP") {
                threadViewModel.stopClicked()
            }.padding()

            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
