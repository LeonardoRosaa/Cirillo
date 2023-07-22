import Foundation

protocol NotificationGateway {
    
    func requestPermission(completionHandler: @escaping (Bool, Error?) -> Void)
    
    func push(id: String, title: String, description: String);
}
