//
//  RunViewSync.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


//
//  RunViewSync.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//

// Call lengthyOperation directly
// Call a View based on a given version


import SwiftUI

// MARK: - Run View

struct RunViewSync: View {
    @State var message: String
    @State var version: String
    @State private var isRunning = false

    var body: some View {
        VStack {
            Text(message)
            Button {
                isRunning = true
                lengthyOperation()
            } label: {
                Text("Show version \(version)")
            }
        }

        if isRunning {
            if version == "4" {
                View3(show: $isRunning)
            }
        }
    }
}

#Preview {
    @Previewable @State var message: String = "Hello, World!"
    RunViewSync(message: message, version: "4")
}
