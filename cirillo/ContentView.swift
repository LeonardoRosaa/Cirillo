import SwiftUI
import UserNotifications
import Swinject

struct ContentView: View {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        DIContainer.shared.resolve(type: NotificationService.self)?.requestPermission()
    }
    
    var body: some View {
        ClockPage().frame(minWidth: 800, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity).padding([.all], 40).background(Color.background.ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let window = NSApplication.shared.windows.first

        window?.titlebarAppearsTransparent = true
        window?.title = ""
    }
}
