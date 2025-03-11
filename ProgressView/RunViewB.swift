//
//  ContentView.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/3/25.
//

import SwiftUI

struct RunView: View {
    @StateObject private var run = gRun
    @State private var progress: Double = 0.0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in
                    progress = run.progress
                    if progress >= 100.0 {
                        run.isRunning = false
                    }
                }
            Text("\(Int(progress))/100")
        }
        .padding()
    }
}

//struct RunView: View {
//    @State private var progress = 0.1
//
//    var body: some View {
//        ProgressView(value: progress,
//                     label: { Text("Processing...") },
//                     currentValueLabel: { Text(progress.formatted(.percent.precision(.fractionLength(0)))) })
//            .padding()
//            .task {
//                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//
//                    self.progress += 0.1
//
//                    if self.progress > 1.0 {
//                        self.progress = 0.0
//                    }
//                }
//            }
//    }
//}

#Preview {
    RunView()
}
