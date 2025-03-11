//
//  Run 2.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/10/25.
//


//
//  run.swift
//  ProgressView
//
//  Created by Phil Kelly on 3/3/25.
//

import Foundation

var gRun = Run()

class Run : ObservableObject {
    var progress: Double = 0
    @Published var isRunning: Bool = false
    
    func longRunningTask() {
        progress = 0
        while progress < 100 {
            progress += 10
            longRunningTask2()
//            Task {
//                await longRunningAsyncTask()
//            }
            print ("\(progress)")
        }
    }
}

func longRunningTask2() {
    for i in 0..<1000000 {
        let _ = i * 2
    }
}

func longRunningAsyncTask() async {
    do {
        try await Task.sleep(for: .milliseconds(500))
    } catch {
        print("Error: %{public}@\n", error.localizedDescription)
    }
}


//func longRunningAsyncTask(_ run: Run) async {
//    run.progress = 0
//    while run.progress < 100 {
//        run.progress += 10
//        do {
//            try await Task.sleep(for: .milliseconds(500))
//            print ("\(run.progress)")
//        } catch {
//            print("Error: %{public}@\n", error.localizedDescription)
//        }
//    }
//}

//func longRunningAsyncTask() async {
//    var start = 0
//    while start < 100 {
//        start += 10
//        do {
//            try await Task.sleep(for: .milliseconds(500))
//            print ("\(start)")
//        } catch {
//            print("Error: %{public}@\n", error.localizedDescription)
//        }
//    }
//}
//
//func longRunningTask() {
//    Task {
//        await longRunningAsyncTask()
//    }
//}
