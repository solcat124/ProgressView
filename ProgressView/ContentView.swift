//
//  ContentView.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var run = gRun
    @State private var isRunningB = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()

        VStack {
            Button {
                run.isRunning = true
                DispatchQueue.global(qos: .background).async {
                    run.longRunningTask()
                }
            } label: {
                Label("Run Version A", systemImage: "doc.circle")
            }
        }
        .padding()

        if run.isRunning {
            RunView()
        }

        VStack {
            Button {
                isRunningB = true
                DispatchQueue.global(qos: .background).async {
                    longRunningTaskB()
                }
            } label: {
                Label("Run Version B", systemImage: "doc.circle")
            }
        }
        .padding()

        if isRunningB {
            RunViewB()
        }


    }
}

#Preview {
    ContentView()
}
