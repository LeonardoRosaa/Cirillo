import Foundation
import UserNotifications

class UserNotificationCenterGateway : NotificationGateway {
    let notificationCenter: UNUserNotificationCenter
    
    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    func requestPermission(completionHandler: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: completionHandler)
    }
    
    func push(id: String, title: String, description: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = description
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        notificationCenter.add(request)
    }
}
