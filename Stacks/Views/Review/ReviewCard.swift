import SwiftUI

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            // User Info
            HStack {
                Circle()
                    .fill(AppTheme.Colors.accent)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String((review.user?.displayName ?? review.user?.username ?? "U").prefix(1)).uppercased())
                            .font(AppTheme.Typography.bodyBold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(review.user?.displayName ?? review.user?.username ?? "Anonymous")
                        .font(AppTheme.Typography.bodyBold)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text(formatDate(review.createdAt))
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= review.rating ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.Colors.accent)
                    }
                }
            }
            
            // Review Content
            Text(review.reviewContent)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            // Helpful Button
            Button(action: {}) {
                HStack(spacing: 4) {
                    Image(systemName: "hand.thumbsup")
                    Text("Helpful (\(review.helpfulVotes))")
                }
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.accent)
            }
        }
        .padding()
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    ReviewCard(review: Review(
        id: 1,
        userID: 1,
        bookID: 1,
        reviewContent: "This is a great book! I really enjoyed reading it.",
        rating: 5,
        helpfulVotes: 12,
        status: .published,
        privacySetting: .public,
        createdAt: Date(),
        updatedAt: Date(),
        user: nil,
        book: nil
    ))
    .padding()
    .background(AppTheme.Colors.background)
}

