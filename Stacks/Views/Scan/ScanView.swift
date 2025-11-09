import SwiftUI
import AVFoundation

struct ScanView: View {
    @EnvironmentObject var bookViewModel: BookViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isScanning = false
    @State private var scannedISBN: String?
    @State private var showManualEntry = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: AppTheme.Spacing.xl) {
                    Spacer()
                    
                    // Camera Preview Placeholder
                    ZStack {
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .fill(AppTheme.Colors.cardBackground)
                            .frame(height: 400)
                        
                        VStack(spacing: AppTheme.Spacing.md) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppTheme.Colors.accent)
                            
                            Text("Point camera at book cover or barcode")
                                .font(AppTheme.Typography.body)
                                .foregroundColor(AppTheme.Colors.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, AppTheme.Spacing.lg)
                        }
                        
                        // Scanning overlay
                        if isScanning {
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                                .stroke(AppTheme.Colors.accent, lineWidth: 3)
                                .frame(height: 400)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    // Instructions
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("How to scan")
                            .font(AppTheme.Typography.bodyBold)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            InstructionRow(text: "Position book cover or barcode in frame")
                            InstructionRow(text: "Ensure good lighting")
                            InstructionRow(text: "Hold steady until scan completes")
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: AppTheme.Spacing.md) {
                        Button(action: {
                            isScanning.toggle()
                            // Simulate scan after delay
                            if isScanning {
                                Task {
                                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                                    scannedISBN = "9780143127741"
                                    isScanning = false
                                    
                                    // Auto-add book if found
                                    if let userID = authViewModel.currentUser?.id {
                                        await bookViewModel.addBookToLibrary(userID: userID, bookID: 1, readingStatus: .owned)
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: isScanning ? "stop.fill" : "camera.fill")
                                Text(isScanning ? "Stop Scanning" : "Start Scanning")
                            }
                        }
                        .buttonStyle(.primary)
                        
                        Button(action: {
                            showManualEntry = true
                        }) {
                            Text("Enter ISBN Manually")
                        }
                        .buttonStyle(.secondary)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, AppTheme.Spacing.xl)
                }
            }
            .navigationTitle("Scan Book")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showManualEntry) {
                ManualEntryView()
                    .environmentObject(bookViewModel)
            }
        }
    }
}

struct InstructionRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppTheme.Colors.accent)
                .font(.system(size: 14))
            
            Text(text)
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
    }
}

struct ManualEntryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bookViewModel: BookViewModel
    @State private var isbn = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: AppTheme.Spacing.lg) {
                    Text("Enter ISBN")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .padding(.top, AppTheme.Spacing.xl)
                    
                    TextField("ISBN", text: $isbn)
                        .textFieldStyle(.plain)
                        .padding()
                        .background(AppTheme.Colors.cardBackground)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .keyboardType(.numberPad)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    Button(action: {
                        Task {
                            bookViewModel.searchQuery = isbn
                            await bookViewModel.searchBooks()
                            dismiss()
                        }
                    }) {
                        Text("Search")
                    }
                    .buttonStyle(.primary)
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .disabled(isbn.isEmpty)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.accent)
                }
            }
        }
    }
}

#Preview {
    ScanView()
        .environmentObject(BookViewModel())
        .environmentObject(AuthViewModel())
}

