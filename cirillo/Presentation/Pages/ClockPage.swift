import SwiftUI
import UserNotifications

struct ClockPage: View {
    
    @ObservedObject var clockObservable: ClockObservable
    
    init() {
        self.clockObservable = DIContainer.shared.resolve(type: ClockObservable.self)!
        
        clockObservable.start()
    }
    
    func startOrCancel() {
        withAnimation {
            clockObservable.startOrCancel()
        }
    }
    
    var body: some View {
        VStack {
            Clock(time: clockObservable.initialTime, duration: clockObservable.duration)
            HStack {
                ClockButton.normal(image: clockObservable.status.isStopped ? "play.fill" : "stop.fill", action: clockObservable.startOrCancel).padding()
                ClockButton.outline(image: "restart", action: clockObservable.restart).padding()
            }.padding([.top], 20)
        }.onReceive(clockObservable.timer) { _ in
            withAnimation {
                clockObservable.countdown()
            }
        }
    }
}

struct ClockPage_Previews: PreviewProvider {
    static var previews: some View {
        ClockPage()
    }
}
