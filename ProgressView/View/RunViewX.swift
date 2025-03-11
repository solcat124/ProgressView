//
//  RunViewX.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//

// Call lengthyOperation directly; no progress view is shown


import SwiftUI

struct RunViewX: View {
    var body: some View {
        VStack {
            Text("No progress view")
            Button {
                lengthyOperation()
            } label: {
                Text("Show version X")
            }
        }
     }
}

#Preview {
    RunViewX()
}
