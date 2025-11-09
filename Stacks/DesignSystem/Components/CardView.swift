import SwiftUI

/// Reusable card component
struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

/// Book cover card component
struct BookCoverCard: View {
    let book: Book
    let size: CGSize
    var onTap: (() -> Void)?
    
    init(book: Book, size: CGSize = CGSize(width: 120, height: 180), onTap: (() -> Void)? = nil) {
        self.book = book
        self.size = size
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: { onTap?() }) {
            AsyncImage(url: URL(string: book.coverImageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    AppTheme.Colors.surface
                    Image(systemName: "book.closed")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
            .frame(width: size.width, height: size.height)
            .cornerRadius(AppTheme.CornerRadius.small)
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

