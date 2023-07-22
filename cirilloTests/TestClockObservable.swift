import XCTest
import Mockingbird

@testable import cirillo

final class TestClockObservable: XCTestCase {
    
    var clockObservable: ClockObservable!
    
    var notificationService: NotificationService!

    override func setUp() async throws {
        notificationService = mock(NotificationService.self)
        
        clockObservable = ClockObservable(
            timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            initialTime: INITIAL_POMODORO_TIME,
            notificationService: notificationService
        )
    }
    
    func testStartMethod() {
        clockObservable.start()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_POMODORO_TIME), "The duration is not the initial pomodoro time")
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.running, "The clock status is not running")
    }
    
    func testCancelMethod() {
        clockObservable.cancel()
        
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.stopped, "The clock status is not stopped")
    }
    
    func testResetForThePomodoroTimeMethod() {
        clockObservable.restart()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_POMODORO_TIME), "The duration is not the initial pomodoro time")
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.running, "The clock status is not running")
    }
    
    func testResetForTheRestTimeMethod() {
        clockObservable = ClockObservable(
            timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            initialTime: INITIAL_REST_TIME,
            notificationService: notificationService
        )
        
        clockObservable.restart()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_REST_TIME), "The duration is not the initial rest time")
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.running, "The clock status is not running")
    }
    
    func testResetForTheLongRestTimeMethod() {
        clockObservable = ClockObservable(
            timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            initialTime: INITIAL_LONG_REST_TIME,
            notificationService: notificationService
        )
        
        clockObservable.restart()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_LONG_REST_TIME), "The duration is not the initial long rest time")
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.running, "The clock status is not running")
    }
    
    func testSetTheStateToRestCountdownMethod() {
        given(notificationService.push(title: any(), description: any())).willReturn()

        clockObservable = ClockObservable(
            timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            duration: .seconds(0),
            notificationService: notificationService
        )
        
        clockObservable.countdown()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_REST_TIME), "The duration is not the initial rest time")
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.stopped, "The clock status is not running")
        XCTAssertEqual(clockObservable.state, ClockTimeState.rest, "The clock state is not rest")
        
        verify(notificationService.push(title: any(), description: any())).wasCalled(1)
    }
    
    func testSetTheStateToLongRestCountdownMethod() {
        given(notificationService.push(title: any(), description: any())).willReturn()
        
        clockObservable = ClockObservable(
            timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            duration: .seconds(0),
            times: 3,
            notificationService: notificationService
        )
        
        clockObservable.countdown()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_LONG_REST_TIME), "The duration is not the initial long rest time")
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.stopped, "The clock status is not running")
        XCTAssertEqual(clockObservable.state, ClockTimeState.longRest, "The clock state is not long rest")
        
        verify(notificationService.push(title: any(), description: any())).wasCalled(1)
    }
    
    func testSetTheStateToNormalAfterLongRestingCountdownMethod() {
        given(notificationService.push(title: any(), description: any())).willReturn()

        clockObservable = ClockObservable(
            timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            duration: .seconds(0),
            state: .longRest,
            notificationService: notificationService
        )
        
        clockObservable.countdown()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_POMODORO_TIME), "The duration is not the initial normal time")
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.stopped, "The clock status is not running")
        XCTAssertEqual(clockObservable.state, ClockTimeState.normal, "The clock state is not normal")
        XCTAssertEqual(clockObservable.times, 0, "The times is not zero")
        
        verify(notificationService.push(title: any(), description: any())).wasCalled(1)
    }
    
    func testSetTheStateToNormalAfterRestingCountdownMethod() {
        given(notificationService.push(title: any(), description: any())).willReturn()

        clockObservable = ClockObservable(
            timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            duration: .seconds(0),
            state: .rest,
            notificationService: notificationService
        )
        
        clockObservable.countdown()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_POMODORO_TIME), "The duration is not the initial normal time")
        XCTAssertEqual(clockObservable.status, ClockTimeStatus.stopped, "The clock status is not running")
        XCTAssertEqual(clockObservable.state, ClockTimeState.normal, "The clock state is not normal")
        
        verify(notificationService.push(title: any(), description: any())).wasCalled(1)
    }
    
    func testDecreaseDurationCountdownMethod() {
        given(notificationService.push(title: any(), description: any())).willReturn()

        clockObservable = ClockObservable(
            timer: Timer.publish(every: 1, on: .main, in: .common).autoconnect(),
            duration: .seconds(INITIAL_POMODORO_TIME),
            state: .rest,
            notificationService: notificationService
        )
        
        clockObservable.countdown()
        
        XCTAssertEqual(clockObservable.duration, Duration.seconds(INITIAL_POMODORO_TIME - 1), "The duration is not the initial long rest time")
        
        verify(notificationService.push(title: any(), description: any())).wasNeverCalled()
    }
}
