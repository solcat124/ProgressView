//
//  longTask.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


import Foundation

var lengthyProgress: Double = 0

// MARK: - Code without async/await

func lengthyOperation() {
    print ("long running function: start")
    lengthyProgress = 0
    while lengthyProgress < 100 {
        lengthyProgress += 10
        lengthyStep()
        print ("long running function: progress = \(lengthyProgress)")
    }
    print ("long running function: done")
}

func lengthyStep() {
    for i in 0..<1000000 {
        let _ = i * 2
    }
}

// MARK: - Code using async/await

func lengthyOperationAsync() async {
    print ("long running function: start")
    lengthyProgress = 0
    while lengthyProgress < 100 {
        lengthyProgress += 10
        await lengthyStepAsync()
        print ("long running function: progress = \(lengthyProgress)")
    }
    print ("long running function: done")
}

func lengthyStepAsync() async {
    for i in 0..<1000000 {
        let _ = i * 2
    }
}
