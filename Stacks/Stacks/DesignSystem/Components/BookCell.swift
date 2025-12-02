import SwiftUI

struct BookCell: View {
    let book: Book
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Book cover
                Group {
                    if let coverUrl = book.coverUrl, let url = URL(string: coverUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "book.closed")
                                        .foregroundColor(.gray)
                                )
                        }
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "book.closed")
                                    .foregroundColor(.gray)
                            )
                    }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Book info
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.bookTitle)
                        .foregroundColor(.primaryText)
                        .lineLimit(2)
                    
                    Text(book.author)
                        .font(.bookAuthor)
                        .foregroundColor(.secondaryText)
                        .lineLimit(1)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

