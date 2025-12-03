import SwiftUI

struct NotificationsView: View {
    let coordinator: AppCoordinator
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark navy background - fills entire screen
                Color.shelfBackgroundDark
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 16) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.whiteText.opacity(0.6))
                    
                    Text("No notifications yet")
                        .font(.title2)
                        .foregroundColor(.whiteText)
                    
                    Text("You'll see notifications here when you receive them")
                        .font(.body)
                        .foregroundColor(.whiteText.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .ignoresSafeArea(.all)
        }
        .ignoresSafeArea(.all)
    }
}

