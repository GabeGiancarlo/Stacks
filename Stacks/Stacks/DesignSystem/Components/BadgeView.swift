import SwiftUI

struct BadgeView: View {
    let badge: Badge
    
    var badgeColor: Color {
        switch badge.tier {
        case .bronze:
            return .bronzeBadge
        case .silver:
            return .silverBadge
        case .gold:
            return .goldBadge
        case .platinum:
            return .platinumBadge
        }
    }
    
    var badgeImage: String {
        switch badge.tier {
        case .bronze:
            return "bronze-badge"
        case .silver:
            return "silder-badge" // Note: typo in asset name
        case .gold:
            return "gold-badge"
        case .platinum:
            return "plat-badge"
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(badgeImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
            
            Text(badge.name)
                .font(.captionBold)
                .foregroundColor(.primaryText)
            
            if let criteria = badge.criteria {
                Text(criteria)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

