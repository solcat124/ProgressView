//
//  RunViewDispatch 2.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


//
//  RunViewDispatch.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//

// Call lengthyOperation as part of a DispatchQueue
// Call a View based on a given version


import SwiftUI

// MARK: - Run View

struct RunViewDispatch: View {
    @State var message: String
    @State var version: String
    @State private var isRunning = false

    var body: some View {
        VStack {
            Text(message)
            Button {
                isRunning = true
                DispatchQueue.global(qos: .background).async {
                    lengthyOperation()
                }
            } label: {
                Text("Show version \(version)")
            }
        }
        .padding()

        if isRunning {
            if version == "1" {
                View1(show: $isRunning)
            }
            if version == "2" {
                View2(show: $isRunning)
            }
            if version == "3" {
                View3(show: $isRunning)
            }
        }
    }
}

#Preview {
    @Previewable @State var message: String = "Hello, World!"
    RunViewDispatch(message: message, version: "2")
}
