//
//  View0.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//

// MARK: - Progress View

// Display ProgressView with static progress. Since the progress doesn't change, the user toggles turning on and off the display
// - total = 0 displays an animation
// - total = non-zero displays static progress

import SwiftUI

struct View0: View {
    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: 0, total: 0.0)
            Text("\(Int(0))/100")
        }
        .padding()

        VStack(alignment: .leading) {
            ProgressView("Processing...", value: 20, total: 100.0)
            Text("\(Int(20))/100")
        }
        .padding()
    }
}

#Preview {
    RunView0()
    View0()
}


// MARK: - Run View
struct RunView0: View {
    @State private var isRunning = false

    var body: some View {
        VStack {
            Text("Static progress display")
            Toggle(isOn: $isRunning) {
                Text("Version 0")
            }
            .toggleStyle(.button)
//            .onChange(of: isRunning) { oldValue, newValue in
//                if newValue == true {
//                    lengthyOperation()
//                }
//            }
        }

        if isRunning {
            View0()
        }
     }
}
