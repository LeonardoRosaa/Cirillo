import SwiftUI

struct OutlineCircle: View {
    
    let color: Color
    
    var to = 1.0
    
    var body: some View {
        Circle().trim(from: 0, to: to).stroke(color, lineWidth: 40).background(color.opacity(0))
    }
}

struct OutlineCircle_Previews: PreviewProvider {
    static var previews: some View {
        OutlineCircle(color: Color.principal)
    }
}
