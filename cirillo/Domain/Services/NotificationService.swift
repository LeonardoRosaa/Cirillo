import Foundation

protocol NotificationService {
    
    func requestPermission()
    
    func push(title: String, description: String)
}

var _enabled: Bool = false

class NotificationServiceImpl : NotificationService {
    
    
    let notificationGateway: NotificationGateway
    
    init(notificationGateway: NotificationGateway, enabled: Bool) {
        self.notificationGateway = notificationGateway
        _enabled = enabled
    }
    
    init(notificationGateway: NotificationGateway) {
        self.notificationGateway = notificationGateway
    }
    
    func requestPermission() {
        notificationGateway.requestPermission() { success, error in
            if (success) {
                _enabled = true
            } else {
                _enabled = false
            }
        }
    }
    
    func push(title: String, description: String) {
        if (_enabled) {
            let identifier = UUID().uuidString
            
            notificationGateway.push(id: identifier, title: title, description: description)
        }
    }
}
