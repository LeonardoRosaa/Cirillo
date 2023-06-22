import SwiftUI

struct Clock: View {
    
    let time: Int
    
    let duration: Duration
    
    var to: Double {
        Double(time - Int(duration.components.seconds)) / Double(time)
    }
    
    var clock: String {
        return duration.formatted(
            .time(pattern: .minuteSecond(padMinuteToLength: 2))
            )
    }
    
    func buildSize(_ width: CGFloat) -> CGFloat {        
        if (width > 1800) {
            return 600
        }
        return width / 2.5
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                ZStack {
                    OutlineCircle(color: Color.gray.opacity(0.2))
                    OutlineCircle(color: Color.principal, to: to).rotationEffect(.init(degrees: -90))
                    Text(clock).font(.system(size: 80))
                }.frame(maxWidth: buildSize(geometry.size.width))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }.clipped()
    }
}
