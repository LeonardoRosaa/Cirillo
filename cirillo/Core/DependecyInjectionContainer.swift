import Foundation
import Swinject
import UserNotifications

protocol DependecyInjectionContainerProtocol {
    func register<Component>(_ type: Component.Type, factory: @escaping (Resolver) -> Component)
    func resolve<Component>(type: Component.Type) -> Component?
}

final class DIContainer: DependecyInjectionContainerProtocol {
    
    let container: Container
    
    init(container: Container) {
        self.container = container
        
        register(NotificationGateway.self) { _ in UserNotificationCenterGateway(
            notificationCenter: UNUserNotificationCenter.current()
        )}
        register(NotificationService.self) { ref in NotificationServiceImpl(
            notificationGateway: ref.resolve(NotificationGateway.self)!
        )}
        register(ClockObservable.self) {
            ref in ClockObservable(
                notificationService: ref.resolve(NotificationService.self)!
            )
        }
    }
    
    private static var instance: DIContainer?
    
    static var shared: DependecyInjectionContainerProtocol {
        instance = instance == nil ? DIContainer(container: Container()) : instance
        
        return instance!
    }
        
    func register<Component>(_ type: Component.Type, factory: @escaping (Resolver) -> Component) {
        container.register(type, factory: factory)
    }
    
    func resolve<Component>(type: Component.Type) -> Component? {
        return container.resolve(type)
    }
}
