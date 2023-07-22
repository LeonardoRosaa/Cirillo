import XCTest
import Mockingbird

@testable import cirillo

final class testNotificationService: XCTestCase {

    var notificationService: NotificationService!
    
    var notificationGateway: NotificationGateway!
    
    override func setUp() async throws {
        notificationGateway = mock(NotificationGateway.self)
    }
    
    func testPushNotificationWhenEnabled() {
        notificationService = NotificationServiceImpl(notificationGateway: notificationGateway, enabled: true)
        
        given(notificationGateway.push(id: any(), title: any(), description: any())).willReturn()
        
        notificationService.push(title: "Time's up", description: "Lets rest right now")
        
        verify(notificationGateway.push(id: any(), title: any(), description: any())).wasCalled()
    }
    
    func testNotPushNotificationWhenDisabled() {
        notificationService = NotificationServiceImpl(notificationGateway: notificationGateway, enabled: false)
                
        notificationService.push(title: "Time's up", description: "Lets rest right now")
        
        verify(notificationGateway.push(id: any(), title: any(), description: any())).wasNeverCalled()
    }
}
