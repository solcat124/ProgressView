//func longRunningTask() async {
func longRunningTask() async {
    var start = 0
    while start < 100 {
        start += 1
        do {
//            try await Task.sleep(for: .milliseconds(100))
            try await Task.sleep(for: .milliseconds(100))
        }
        catch {
            print("Error: %{public}@\n", error.localizedDescription)
        }
    }
    start = 0
    sleep(2)
}

Task {
    do {
        try await Task.sleep(for: .milliseconds(100))
    }
    catch {
        print("Error: %{public}@\n", error.localizedDescription)
    }

}
