//
//  ConsoleView.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 03/09/2022.
//

import SwiftUI

struct ConsoleView: View {
    var content = "Lorem ipsum"
    
    var body: some View {
        return GeometryReader { geometry in
            ScrollView {
                Text(content).font(.smallCaps(.system(size: 12))())
                    .lineLimit(nil)
                    .frame(width: geometry.size.width, alignment: .leading).padding()
                
            }
        }
    }
}
struct ConsoleView_Previews: PreviewProvider {
    static var previews: some View {
        ConsoleView()
    }
}
