//
//  View1 2.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


// Display ProgressView
// progress is updated independent of any model code

import SwiftUI

struct View1: View {
    @Binding var show: Bool
    @State private var progress: Double = 0.0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in
                    if progress < 100.0 {
                        progress += 10
                    } else {
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
    View1(show: $show)
}
