#  Determinate ProgressView

## Getting Started
Displaying something to indicate a task is running is conceptually straightforward:

- start spinner display
- run task
- stop spinner display

Displaying a spinner can use `ProgressView` to manage what the display looks like.
This is relatively straightforward, although the display and run part are coded independently -- they do not share progress information. This makes displaying indeterminate progress very easy, but not so much for determinate progress. 

It is common to see suggestions for creating a determinate progress view:

```
struct ShowProgressView: View {
    @State private var progress: Double = 0.0    

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
        }
    }
}
```

This creates a static view showing the given level of progress. 

Note that if the total value is 0, the progress view displays an animation where the completion bar moves back and forth from 0 to 100. 


Displaying a dynamic level of progress is complicated, as some level of interaction is required so that progress made during the run task is used by the spinner display. In a model-view paradigm, interaction between modeling code and view code is not straightforward. Avoiding the **Publishing changes from background threads is not allowed** warning gets messy.

## Adding a Timer
One way to deal with a dynamic level of progress is to use a timer, where timer events are used to update the view on the status of the model code. This works because the timer event can make use of the `.onReceive` method that deals with concurrency. This avoids warning about publishing changes from background threads.

Here's View code that adds a timer that dynamically creates an event where the progress can be updated.

```
struct ShowProgressView: View {
    @State private var progress: Double = 0.0    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in                // uses the `.onReceive(timer)` call, which allows the progress to be updated.
                    if progress < 100.0 {
                        progress += 10                  // updates progress (but still not dependent on anything)
                    }
                }
            Text("\(Int(progress))/100")
        }
        .padding()
    }
}
```

Although the progress is dynamically updated, it isn't based on model code. So while this might look interesting, it likely isn't very useful without additional coding. We need the `progress` value to be set to a value reported in model code. 

## Asynchronous Operation
Running a model task synchronously with the progress view means that the the progress view will be displayed, the model task will start and run to completion, and and then any progress view updates are made. The result is that the progress display starts with progress at 0, the model task runs, and then the progress display updates, likely with progress at 100 percent.  While the progress view is displayed, actual progress is not effectively displayed. To get around this, the model task can be run asynchronously.

In this code a user launches a model task, say `longRunningFunction` asynchronously: 

```
struct ContentView: View {
    @State var isRunning = false
    
    var body: some View {
        Button {
            isRunning = true                                        // the user wants to run a task that may take awhile and to display progress
            DispatchQueue.global(qos: .background).async {          // indicates that the long-running process should run in parallel with the GUI. Otherwise the GUI won't update until the long-running process completes.
                longRunningFunction()                               // launch the long-running process
            }
        } label: {
            Label("Run")
        }

        if isRunning {                                              
            RunView()                                               // display the progress
        }
    }
}
```

## Linking the View and Model
In the code above the progress view still has no knowledge of the status of `longRunningFunction`. And with no way to set isRunning to `false`, the progress remains displayed after the long-running process completes. (Which may nor may not be desireable. It seems that the timer will continue to run as long as the ShowProgressView is being executed.)

Consider the following model code:

```
var status: Double = 0.0                            // makes the progress of a longRunningFunction available

func longRunningFunction() {                        // a function that takes some time to complete
    status = 0
    while status < 100 {
        status += 10                                // update progress
        lengthyTask()                               // something to simulate a lengthy task
        print ("\(status)")
    }

func lengthyTask() {                                // simulation of processing that can take some time to complete
    for i in 0..<1000000 {                          // avoid sleep-like functions that bring in concepts of concurrency not relevant here
        let _ = i * 2
    }
}
```

It is tempting to implement the lengthy task using a sleep-like function -- it seems so simple, but it leads one down a rabbit hole on how to avoid timer concurrency concerns that are likely not relevant here. Using a processing loop avoids side issues and probably better mimics code in an actual implementation.

The progress view can now be modified to use the status reported by the model code through the global `status` variable that is updated asynchronously.

```
struct ShowProgressView: View {
    @State private var progress: Double = 0.0    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in                // uses the `.onReceive(timer)` call, which allows the progress to be updated.
                    progress = status                   // progress is updated with the current value of status reported by longRunningFunction
                }
            Text("\(Int(progress))/100")
        }
        .padding()
    }
}
```

## A Complete Solution (mostly)

The sequence of events starts when a user presses a start button in the ContentView. This sets `isRunning` to `true` and launches `longRunningFunction`. At the timer intervals, the `progress` is updated to `status` 

To inform the GUI when the process ends, `isRunning` to set to `false` when the progress reaches 100%.

Consider a class Run and a global variable to an instance to it, as well as minor updates to ContentView and ShowProgressView:
:

```
// Model 
var gRun = Run()

class Run : ObservableObject {
    var status: Double = 0                          // reports the progress of a longRunningFunction
    @Published var isRunning: Bool = false          // including this notifies ContentView when the long-running task ends (see ShowProgressView)
    
    func longRunningFunction() {.                   // a function that takes some time to complete
        status = 0
        while status < 100 {
            status += 10                            // update progress
            lengthyTask()                           // something to simulate a lengthy task
            print ("\(status)")
        }
        isRunning = false
    }
}

func lengthyTask() {                                // simulation of processing that can take some time to complete
    for i in 0..<1000000 {                          // avoid sleep-like functions that bring in concepts of concurrency not relevant here
        let _ = i * 2
    }
}
```

```
// Content View
struct ContentView: View {
    @StateObject private var run = gRun
    
    var body: some View {
        VStack {
            Button {
                run.isRunning = true
                DispatchQueue.global(qos: .background).async {
                    run.longRunningFunction()
                }
            } label: {
                Label("Run Version A", systemImage: "doc.circle")
            }
        }
        .padding()

        if run.isRunning {
            RunView()
        }
    }
}
```

```
// Progress View
struct ShowProgressView: View {
    @StateObject private var run = gRun
    @State private var progress: Double = 0.0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in
                    progress = run.progress
                    if progress >= 100.0 {
                        run.isRunning = false           // report the task has been completed
                    }
                }
            Text("\(Int(progress))/100")
        }
        .padding()
    }
}
```

## Stop the Timer
It is possible to kill the timer:

```
timer.upstream.connect().cancel()
```

```
// Progress View
struct ShowProgressView: View {
    @StateObject private var run = gRun
    @State private var progress: Double = 0.0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in
                    progress = run.progress
                    if progress >= 100.0 {
                        timer.upstream.connect().cancel()
                        run.isRunning = false           // report the task has been completed
                    }
                }
            Text("\(Int(progress))/100")
        }
        .padding()
    }
}
```

In this case when the progress becomes 100% the timer stops running and the progress view becomes static. 













## Old material to delete
The sequence of events starts when a user presses a start button and isRunning is set `true`. To inform the GUI when the process ends, the `isRunning` parameter is set `false`.


This code includes a timer. The `.onReceive` method allows `progress` to be updated (and avoid the "Publishing changes from background threads is not allowed" warning.)

```
struct ShowProgressView: View {
    @State private var progress: Double = 0.0    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            ProgressView("Processing...", value: progress, total: 100.0)
                .onReceive(timer) { _ in
                    progress += 10
                    if progress >= 100.0 {
                        run.isRunning = false
                    }
                }
            Text("\(Int(progress))/100")
        }
        .padding()
    }
}
```

This still doesn't address how `progress` can be tied to a function outside of ContentView.

Consider a class Run:

```
var gRun = Run()

class Run : ObservableObject {
    var progress: Double = 0
    @Published var isRunning: Bool = false
    
    func longRunningFunction() {
        progress = 0
        while progress < 100 {
            progress += 10
            longRunningFunction()
            print ("\(progress)")
        }
    }
}

func longRunningFunction() {
    for i in 0..<1000000 {
        let _ = i * 2
    }
}
```

The `progress` parameter is not published as it will be changed in a background thread. The `isRunning` parameter is published.

Displaying the progress view involves something like

```
struct ContentView: View {
    @StateObject private var run = gRun
    var body: some View {
        Button {
            run.isRunning = true
            DispatchQueue.global(qos: .background).async {
                run.longRunningFunction()
            }
        } label: {
            Label("Run")
        }

        if gRun.isRunning {
            RunView()
        }
    }
}
```




