import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var showSidebar = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        // Header with greeting
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Welcome back!")
                                .font(AppTheme.Typography.title1)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            if let user = authViewModel.currentUser {
                                Text(user.displayName ?? user.username)
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, AppTheme.Spacing.md)
                        
                        // Reading Stats
                        if let user = authViewModel.currentUser {
                            ReadingStatsCard(user: user)
                                .padding(.horizontal, AppTheme.Spacing.lg)
                        }
                        
                        // Currently Reading Section
                        if !bookViewModel.userBooks.filter({ $0.readingStatus == .currentlyReading }).isEmpty {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                                Text("Currently Reading")
                                    .font(AppTheme.Typography.title2)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: AppTheme.Spacing.md) {
                                        ForEach(bookViewModel.userBooks.filter { $0.readingStatus == .currentlyReading }) { userBook in
                                            if let book = userBook.book {
                                                CurrentlyReadingCard(userBook: userBook, book: book)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, AppTheme.Spacing.lg)
                                }
                            }
                        }
                        
                        // Recent Activity
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Text("Recent Activity")
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(AppTheme.Colors.primaryText)
                                .padding(.horizontal, AppTheme.Spacing.lg)
                            
                            VStack(spacing: AppTheme.Spacing.sm) {
                                ForEach(bookViewModel.userBooks.prefix(3)) { userBook in
                                    if let book = userBook.book {
                                        ActivityRow(userBook: userBook, book: book)
                                            .padding(.horizontal, AppTheme.Spacing.lg)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, AppTheme.Spacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSidebar = true
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Stacks")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
            }
            .sheet(isPresented: $showSidebar) {
                SidebarView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

struct ReadingStatsCard: View {
    let user: User
    
    var body: some View {
        CardView {
            HStack(spacing: AppTheme.Spacing.xl) {
                StatItem(value: "\(user.totalBooksRead)", label: "Books Read")
                Divider()
                    .background(AppTheme.Colors.secondaryText)
                StatItem(value: "\(user.totalPagesRead)", label: "Pages Read")
                Divider()
                    .background(AppTheme.Colors.secondaryText)
                StatItem(value: "12", label: "This Month")
            }
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            Text(value)
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.accent)
            
            Text(label)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
    }
}

struct CurrentlyReadingCard: View {
    let userBook: UserBook
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            BookCoverCard(book: book, size: CGSize(width: 100, height: 150))
            
            Text(book.title)
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineLimit(2)
                .frame(width: 100)
            
            ProgressView(value: userBook.completionPercentage, total: 100)
                .tint(AppTheme.Colors.accent)
                .frame(width: 100)
            
            Text("\(Int(userBook.completionPercentage))%")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
    }
}

struct ActivityRow: View {
    let userBook: UserBook
    let book: Book
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            BookCoverCard(book: book, size: CGSize(width: 60, height: 90))
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(book.title)
                    .font(AppTheme.Typography.bodyBold)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineLimit(1)
                
                Text(statusText)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                if let rating = userBook.rating {
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.Colors.accent)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var statusText: String {
        switch userBook.readingStatus {
        case .read:
            return "Finished reading"
        case .currentlyReading:
            return "Currently reading"
        case .wantToRead:
            return "Want to read"
        case .owned:
            return "Added to library"
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(BookViewModel())
}

