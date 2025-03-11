//
//  View0 2.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


//
//  View0.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


import SwiftUI

struct View0: View {
    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: 0, total: 0.0)
            Text("\(Int(0))/100")
        }
        .padding()

        VStack(alignment: .leading) {
            ProgressView("Processing...", value: 0, total: 100.0)
            Text("\(Int(0))/100")
        }
        .padding()
    }
}

#Preview {
    View0()
}
