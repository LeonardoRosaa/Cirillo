import Foundation
import SwiftUI
import Combine

let INITIAL_POMODORO_TIME = 1500
let INITIAL_REST_TIME = 300
let INITIAL_LONG_REST_TIME = 1200

enum ClockTimeStatus {
    case stopped
    case running
}

extension ClockTimeStatus {
    var isStopped: Bool {
        self == .stopped
    }
    
    var isRunning: Bool {
        self == .running
    }
}

enum ClockTimeState {
    case rest
    case longRest
    case normal
}

extension ClockTimeState {
    var isLongRest: Bool {
        self == .longRest
    }
    
    var isRest: Bool {
        self == .rest
    }
}

extension Int64 {
    
    var isZero: Bool {
        self == 0
    }
}

class ClockObservable : ObservableObject {
    
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>!
    
    @Published var duration: Duration!
    
    @Published var initialTime: Int
    
    @Published var state: ClockTimeState
    
    @Published var status: ClockTimeStatus
    
    let notificationService: NotificationService
    
    var times = 0;
    
    init(notificationService: NotificationService) {
        self.notificationService = notificationService
        initialTime = INITIAL_POMODORO_TIME
        state = .normal
        status = .stopped
        
        duration = .seconds(self.initialTime)

    }
    
    init(timer: Publishers.Autoconnect<Timer.TimerPublisher>, initialTime: Int, notificationService: NotificationService) {
        self.timer = timer
        self.initialTime = initialTime
        self.notificationService = notificationService

        state = .normal
        status = .stopped
    }
    
    init(timer: Publishers.Autoconnect<Timer.TimerPublisher>, duration: Duration, notificationService: NotificationService) {
        self.timer = timer
        self.duration = duration
        self.initialTime = INITIAL_POMODORO_TIME
        
        self.notificationService = notificationService
        state = .normal
        status = .stopped
    }
    
    init(timer: Publishers.Autoconnect<Timer.TimerPublisher>, duration: Duration, times: Int, notificationService: NotificationService) {
        self.timer = timer
        self.duration = duration
        self.times = times
        
        self.notificationService = notificationService
        self.initialTime = INITIAL_POMODORO_TIME
        state = .normal
        
        status = .stopped
    }
    
    init(timer: Publishers.Autoconnect<Timer.TimerPublisher>, duration: Duration, state: ClockTimeState, notificationService: NotificationService) {
        self.timer = timer
        self.duration = duration
        self.state = state
        
        self.notificationService = notificationService
        self.initialTime = INITIAL_POMODORO_TIME
        status = .stopped
    }
    
    func startOrCancel() {
        if status.isStopped {
            start()
        } else {
            cancel()
        }
    }
    
    func start() {
        duration = .seconds(initialTime)
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        status = .running
    }
    
    func cancel() {
        timer.upstream.connect().cancel()
        status = .stopped
    }
    
    func restart() {
        duration = .seconds(initialTime)
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        status = .running
    }
    
    func countdown() {
        let seconds = duration.components.seconds;

        if seconds.isZero {
            let title = String(localized: "timesUp")
            var description: String = String(localized: "timesUpFocusDescription")
            
            switch state {
                case .normal:
                    times += 1
                
                    if times == 4 {
                        state = .longRest
                        initialTime = INITIAL_LONG_REST_TIME
                    } else {
                        state = .rest
                        initialTime = INITIAL_REST_TIME
                    }
                
                    description = String(localized: "timesUpRestDescription")
            case .rest:
                state = .normal
                initialTime = INITIAL_POMODORO_TIME
            case .longRest:
                times = 0
                state = .normal
                initialTime = INITIAL_POMODORO_TIME
            }
            
            cancel()
            duration = .seconds(initialTime)
            
            notificationService.push(title: title, description: description)
        } else {
            duration -= .seconds(1)
        }
    }
}
