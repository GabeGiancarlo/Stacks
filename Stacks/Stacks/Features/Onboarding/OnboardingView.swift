import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let coordinator: AppCoordinator
    
    let pages = [
        OnboardingPage(
            title: "Track Your Reading",
            description: "Keep track of all the books you've read and want to read",
            imageName: "book.closed"
        ),
        OnboardingPage(
            title: "Write Reviews",
            description: "Share your thoughts and rate the books you've read",
            imageName: "star.fill"
        ),
        OnboardingPage(
            title: "Discover New Books",
            description: "Explore recommendations and find your next great read",
            imageName: "magnifyingglass"
        )
    ]
    
    var body: some View {
        ZStack {
            Image("onboarding background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Button(action: {
                    coordinator.completeOnboarding()
                }) {
                    Text("Get Started")
                        .font(.bodyBold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryButton)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(.primaryButton)
            
            Text(page.title)
                .font(.largeTitle)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.center)
            
            Text(page.description)
                .font(.body)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

