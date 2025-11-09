import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @EnvironmentObject var shelfViewModel: ShelfViewModel
    @State private var selectedFilter: ReadingStatus? = nil
    
    var filteredBooks: [UserBook] {
        if let filter = selectedFilter {
            return bookViewModel.userBooks.filter { $0.readingStatus == filter }
        }
        return bookViewModel.userBooks
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppTheme.Spacing.sm) {
                            FilterButton(title: "All", isSelected: selectedFilter == nil) {
                                selectedFilter = nil
                            }
                            
                            ForEach(ReadingStatus.allCases, id: \.self) { status in
                                FilterButton(title: status.rawValue, isSelected: selectedFilter == status) {
                                    selectedFilter = status
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                    }
                    .padding(.vertical, AppTheme.Spacing.md)
                    
                    // Books Grid
                    if filteredBooks.isEmpty {
                        VStack {
                            Spacer()
                            Image(systemName: "books.vertical")
                                .font(.system(size: 60))
                                .foregroundColor(AppTheme.Colors.secondaryText)
                            
                            Text("No books found")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                                .padding(.top, AppTheme.Spacing.md)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: AppTheme.Spacing.md) {
                                ForEach(filteredBooks) { userBook in
                                    if let book = userBook.book {
                                        NavigationLink(destination: BookDetailView(book: book)) {
                                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                                                BookCoverCard(book: book, size: CGSize(width: 100, height: 150))
                                                
                                                Text(book.title)
                                                    .font(AppTheme.Typography.caption)
                                                    .foregroundColor(AppTheme.Colors.primaryText)
                                                    .lineLimit(2)
                                                    .frame(width: 100)
                                                
                                                StatusBadge(status: userBook.readingStatus)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .padding(.vertical, AppTheme.Spacing.md)
                        }
                    }
                }
            }
            .navigationTitle("My Library")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(isSelected ? AppTheme.Colors.buttonText : AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(isSelected ? AppTheme.Colors.accent : AppTheme.Colors.cardBackground)
                .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
}

struct StatusBadge: View {
    let status: ReadingStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(AppTheme.Typography.caption)
            .foregroundColor(statusColor)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(statusColor.opacity(0.2))
            .cornerRadius(4)
    }
    
    private var statusColor: Color {
        switch status {
        case .read:
            return AppTheme.Colors.read
        case .currentlyReading:
            return AppTheme.Colors.currentlyReading
        case .wantToRead:
            return AppTheme.Colors.wantToRead
        case .owned:
            return AppTheme.Colors.owned
        }
    }
}

#Preview {
    LibraryView()
        .environmentObject(BookViewModel())
        .environmentObject(ShelfViewModel())
}

