//
//  ContentView.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/3/25.
//

import SwiftUI

struct ContentView: View {
     @State private var isRunning = false
    
    var body: some View {
        VStack {
            Text("Progress is independent of the model code")
            Button {
                isRunning = true
                DispatchQueue.global(qos: .background).async {
                    longRunningFunction()
                }
            } label: {
                Text("Show version 1")
            }
        }
        .padding()

        if isRunning {
            View1(show: $isRunning)
        }
    }
}

#Preview {
    ContentView()
}




//struct ContentView: View {
//    @StateObject private var run = gRun
//    @State private var isRunningB = false
//    
//    var body: some View {
//        VStack {
//            Button {
//                run.isRunning = true
//                DispatchQueue.global(qos: .background).async {
//                    run.longRunningTask()
//                }
//            } label: {
//                Text("Show version 1")
//            }
//        }
//        .padding()
//
//        if run.isRunning {
//            RunView()
//        }
//
//        VStack {
//            Button {
//                isRunningB = true
//                DispatchQueue.global(qos: .background).async {
//                    longRunningTaskB()
//                }
//            } label: {
//                Label("Run Version B", systemImage: "doc.circle")
//            }
//        }
//        .padding()
//
//        if isRunningB {
//            RunViewB()
//        }
//
//
//    }
