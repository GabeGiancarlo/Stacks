//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI
import ServicesLayer

// MARK: - ShopView

public struct ShopView: View {
    @State private var shelfStyles: [ShelfStyle] = ShelfStyle.mockData
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Customize Your Shelves")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Choose from beautiful themes to personalize your library")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    // Shelf Styles
                    ForEach(shelfStyles) { style in
                        ShelfStyleCard(style: style)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - ShelfStyleCard

struct ShelfStyleCard: View {
    let style: ShelfStyle
    @State private var isPurchasing = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Preview
            RoundedRectangle(cornerRadius: 12)
                .fill(style.primaryColor.opacity(0.2))
                .frame(height: 120)
                .overlay(
                    VStack {
                        Image(systemName: style.iconName)
                            .font(.title)
                            .foregroundColor(style.primaryColor)
                        
                        Text(style.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                )
            
            // Details
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(style.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(style.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        if style.price == 0 {
                            Text("FREE")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        } else {
                            Text("$\(style.price, specifier: "%.2f")")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        
                        if style.isPurchased {
                            Text("Owned")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
                
                // Purchase Button
                Button(action: {
                    if !style.isPurchased {
                        isPurchasing = true
                        // Simulate purchase
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isPurchasing = false
                        }
                    }
                }) {
                    HStack {
                        if isPurchasing {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: style.isPurchased ? "checkmark" : (style.price == 0 ? "square.and.arrow.down" : "cart"))
                        }
                        
                        Text(style.isPurchased ? "Purchased" : (style.price == 0 ? "Download" : "Purchase"))
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(style.isPurchased ? Color.green : Color.blue)
                    .cornerRadius(8)
                }
                .disabled(style.isPurchased || isPurchasing)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
} 