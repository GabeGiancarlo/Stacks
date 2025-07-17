//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation
import SwiftUI
import StoreKit

// MARK: - ShelfStyle

public struct ShelfStyle: Identifiable, Codable, Equatable {
    public let id: UUID
    public let name: String
    public let description: String
    public let price: Double
    public let iconName: String
    public let primaryColor: Color
    public let productID: String?
    public var isPurchased: Bool
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        price: Double,
        iconName: String,
        primaryColor: Color,
        productID: String? = nil,
        isPurchased: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.iconName = iconName
        self.primaryColor = primaryColor
        self.productID = productID
        self.isPurchased = isPurchased
    }
}

// MARK: - ShelfStyleStore

public class ShelfStyleStore: ObservableObject {
    @Published public var styles: [ShelfStyle] = []
    
    public init() {
        loadStyles()
    }
    
    private func loadStyles() {
        styles = ShelfStyle.mockData
    }
    
    public func purchaseStyle(_ style: ShelfStyle) async throws {
        // In a real implementation, this would use StoreKit 2
        // For now, we'll simulate a purchase
        
        guard !style.isPurchased else {
            throw ShelfStyleError.alreadyPurchased
        }
        
        if style.price == 0 {
            // Free style - immediately mark as purchased
            markStyleAsPurchased(style.id)
            return
        }
        
        // Simulate StoreKit 2 purchase flow
        try await simulatePurchase(style)
        markStyleAsPurchased(style.id)
    }
    
    private func simulatePurchase(_ style: ShelfStyle) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Simulate random purchase success/failure (90% success rate)
        if Int.random(in: 1...10) > 9 {
            throw ShelfStyleError.purchaseFailed
        }
    }
    
    private func markStyleAsPurchased(_ styleID: UUID) {
        DispatchQueue.main.async {
            if let index = self.styles.firstIndex(where: { $0.id == styleID }) {
                self.styles[index].isPurchased = true
            }
        }
    }
    
    public func restorePurchases() async throws {
        // In a real implementation, this would restore from StoreKit
        // For now, we'll mark all paid styles as purchased for demo
        
        DispatchQueue.main.async {
            for index in self.styles.indices {
                if self.styles[index].price > 0 {
                    self.styles[index].isPurchased = true
                }
            }
        }
    }
}

// MARK: - ShelfStyleError

public enum ShelfStyleError: Error, LocalizedError {
    case alreadyPurchased
    case purchaseFailed
    case productNotFound
    
    public var errorDescription: String? {
        switch self {
        case .alreadyPurchased:
            return "Style already purchased"
        case .purchaseFailed:
            return "Purchase failed. Please try again."
        case .productNotFound:
            return "Product not found"
        }
    }
}

// MARK: - Mock Data

public extension ShelfStyle {
    static let mockData: [ShelfStyle] = [
        ShelfStyle(
            name: "Classic Wood",
            description: "Traditional wooden shelves with warm tones",
            price: 0.0,
            iconName: "rectangle.stack",
            primaryColor: .brown,
            isPurchased: true
        ),
        ShelfStyle(
            name: "Modern Glass",
            description: "Sleek glass shelves with blue accent lighting",
            price: 0.99,
            iconName: "rectangle.stack.fill",
            primaryColor: .blue,
            productID: "com.intitled.shelf.glass"
        ),
        ShelfStyle(
            name: "Vintage Leather",
            description: "Luxurious leather-bound shelves with gold details",
            price: 1.99,
            iconName: "books.vertical.fill",
            primaryColor: Color(.systemBrown),
            productID: "com.intitled.shelf.leather"
        ),
        ShelfStyle(
            name: "Minimalist White",
            description: "Clean, minimal white shelves for a modern look",
            price: 0.99,
            iconName: "rectangle.on.rectangle",
            primaryColor: .gray,
            productID: "com.intitled.shelf.minimal"
        )
    ]
} 