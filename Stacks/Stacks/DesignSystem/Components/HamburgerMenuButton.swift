import SwiftUI

struct HamburgerMenuButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.primaryText)
                .font(.system(size: 20, weight: .medium))
        }
        .buttonStyle(.plain)
    }
}

