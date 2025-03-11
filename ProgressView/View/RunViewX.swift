//
//  ViewX.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//

import SwiftUI

struct RunViewX: View {
    var body: some View {
        VStack {
            Button {
                lengthyOperation()
            } label: {
                Text("Run")
            }
        }
     }
}

#Preview {
    RunViewX()
}
