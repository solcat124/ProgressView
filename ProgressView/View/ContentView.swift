//
//  ContentView.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/3/25.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        RunViewX()
            .padding()
        RunView0()
            .padding()
        RunViewDispatch(message: "Progress is independent of the model code", version: "1")
            .padding()
        RunViewDispatch(message: "Progress is dependent on the model code",   version: "2")
            .padding()
        RunViewDispatch(message: "Version 2 plus timer is killed when done",  version: "3")
            .padding()
        RunViewSync    (message: "Version 3 but task runs synchronously",     version: "4")
            .padding()
        RunViewAsync   (message: "Version 3 but runs async task",             version: "5")
            .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ContentView()
}
