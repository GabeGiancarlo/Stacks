//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI
import DataLayer

// MARK: - BookSpineView

public struct BookSpineView: View {
    let book: Book
    
    public init(book: Book) {
        self.book = book
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Book cover
            AsyncImage(url: book.coverURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "book.closed")
                            .font(.title2)
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            .shadow(radius: 4)
            
            // Book info
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text(book.authors.joined(separator: ", "))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 80)
    }
} 