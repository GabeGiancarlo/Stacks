import SwiftUI

struct ManualBookEntryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var libraryService = LibraryService.shared
    
    @State private var title = ""
    @State private var author = ""
    @State private var isbn = ""
    @State private var description = ""
    @State private var publishedYear = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Book Information") {
                    TextField("Title *", text: $title)
                    TextField("Author *", text: $author)
                    TextField("ISBN", text: $isbn)
                        .keyboardType(.numberPad)
                    TextEditor(text: $description)
                        .frame(minHeight: 80)
                        .overlay(
                            Group {
                                if description.isEmpty {
                                    Text("Description")
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                    TextField("Published Year", text: $publishedYear)
                        .keyboardType(.numberPad)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.error)
                    }
                }
            }
            .navigationTitle("Add Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbarContent)
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                Task {
                    await saveBook()
                }
            }
            .disabled(title.isEmpty || author.isEmpty || isLoading)
        }
    }
    
    private func saveBook() async {
        isLoading = true
        errorMessage = nil
        
        let year = publishedYear.isEmpty ? nil : Int(publishedYear)
        
        do {
            _ = try await libraryService.addBook(
                isbn: isbn.isEmpty ? nil : isbn,
                title: title,
                author: author,
                description: description.isEmpty ? nil : description,
                publishedYear: year,
                coverImageData: nil
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

