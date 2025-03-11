//
//  View3.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


// Display ProgressView
// progress is dependent model code

import SwiftUI

// MARK: - Progress View

struct View3: View {
    @Binding var show: Bool
    @State private var progress: Double = 0.0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in
                    progress = lengthyProgress
                    if progress >= 100.0 {
                        show = false
                        timer.upstream.connect().cancel()
                    }
                }
            Text("\(Int(progress))/100")
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var show: Bool = true
    RunViewDispatch(message: "Version 2 but task runs synchronously", version: "3")
    View3(show: $show)
}
