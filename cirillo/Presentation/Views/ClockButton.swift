import SwiftUI

struct ClockButton: View {
    
    var action: () -> Void
    
    var image: String
    
    var isOutline: Bool = false
    
    init(image: String, isOutline: Bool, action: @escaping () -> Void) {
        self.action = action
        self.image = image
        self.isOutline = isOutline
    }
    
    static func outline(image: String, action: @escaping () -> Void) -> ClockButton {
        return ClockButton(image: image, isOutline: true, action: action)
    }
    
    static func normal(image: String, action: @escaping () -> Void) -> ClockButton {
        return ClockButton(image: image, isOutline: false, action: action)
    }
    
    var body: some View {
        let view = Button(action: action, label: {
            Image(systemName: image).resizable().frame(width: 40, height: 40).foregroundColor(isOutline ? Color.principal : Color.white).padding([.trailing], isOutline ? 5 : 0)
        }).buttonStyle(PlainButtonStyle())
            .padding([.all], .zero).frame(maxWidth: 100, maxHeight: 100)
        
        if isOutline {
            view.background(Color.principal.opacity(0)).overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.principal, lineWidth: 4)
            )
        } else {
            view.background(Color.principal).cornerRadius(100).background(Color.principal).cornerRadius(100)
        }
        
    }
}
