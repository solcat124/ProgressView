//
//  RunViewAsync.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


// Call lengthyOperation that uses async/await
// Call a View based on a given version


import SwiftUI

// MARK: - Run View

struct RunViewAsync: View {
    @State var message: String
    @State var version: String
    @State private var isRunning = false

    var body: some View {
        VStack {
            Text(message)
            Button {
                isRunning = true
                Task { @MainActor in
                    await lengthyOperationAsync()
                }
            } label: {
                Text("Show version \(version)")
            }
        }

        if isRunning {
            if version == "5" {
                View3(show: $isRunning)
            }
        }
    }
}

#Preview {
    @Previewable @State var message: String = "Hello, World!"
    RunViewDispatch(message: message, version: "5")
}
