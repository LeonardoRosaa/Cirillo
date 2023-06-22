import SwiftUI
import UserNotifications

let INITIAL_POMODORO_TIME = 1500
let INITIAL_REST_TIME = 400

struct ClockPage: View {
    
    @State private var duration: Duration = .seconds(INITIAL_POMODORO_TIME)
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var hasStopped = false
    
    @State var time = INITIAL_POMODORO_TIME
    
    @State var isResting = false
   
    
    func startOrCancel() -> Void {
        withAnimation {
            if hasStopped {
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            } else {
                self.timer.upstream.connect().cancel()
            }
            
            hasStopped.toggle()
        }
        
    }
    
    func cancel() -> Void {
        withAnimation {
            self.timer.upstream.connect().cancel()

        }
    }
    
    func start() -> Void {
        withAnimation {
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        }
    }
    
    func restart() -> Void {
        withAnimation {
            duration = .seconds(time)
        }
    }
    
    func countdown() -> Void {
        withAnimation {
            let seconds = duration.components.seconds
            
            if seconds >= 0 {
                if seconds > 0 {
                    duration -= .seconds(1)
                }
                
                if seconds == 0 {
                    isResting.toggle()
                    time = isResting ? INITIAL_REST_TIME : INITIAL_POMODORO_TIME
                    
                    hasStopped = true
                    cancel()
                    duration = .seconds(time)
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Your time is up"
                    content.subtitle = isResting ? "Let's take a break" : "Let's focus"
                    content.sound = UNNotificationSound.default

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    UNUserNotificationCenter.current().add(request)
                }
            }
        }
      
    }
    
    var body: some View {
        VStack {
            Clock(time: time, duration: duration)
            HStack {
                ClockButton.normal(image: hasStopped ? "play.fill" : "stop.fill", action: startOrCancel).padding()
                ClockButton.outline(image: "restart", action: restart).padding()
            }.padding([.top], 20)
        }.onReceive(timer) { _ in
            countdown()
        }
    }
}

struct ClockPage_Previews: PreviewProvider {
    static var previews: some View {
        ClockPage()
    }
}
