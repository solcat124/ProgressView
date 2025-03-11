//
//  ContentView.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        
        VStack {
            Button {
//                DispatchQueue.global(qos: .background).async {
                    longRunningTask()
//                }
            } label: {
                Label("Run", systemImage: "doc.circle")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
