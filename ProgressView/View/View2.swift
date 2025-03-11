//
//  View1 2.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


// Display ProgressView
// progress is dependent model code

import SwiftUI

// MARK: - Progress View

struct View2: View {
    @Binding var show: Bool
    @State private var progress: Double = 0.0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in
                    progress = lengthyProgress     // lengthyProgress is updated in model code
                    if progress >= 100.0 {
                        show = false
                    }
                }
            Text("\(Int(progress))/100")
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var show: Bool = true
    RunViewDispatch(message: "Progress is independent on the model code", version: "2")
    View2(show: $show)
}
