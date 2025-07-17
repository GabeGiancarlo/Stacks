//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI
import VisionKit
import ServicesLayer

// MARK: - ScannerView

public struct ScannerView: View {
    @State private var isShowingScanner = false
    @State private var scannedISBN: String?
    @State private var showingScanResult = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Scan Book ISBN")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Point your camera at a book's barcode to add it to your library")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    if DataScannerViewController.isSupported {
                        isShowingScanner = true
                    }
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Start Scanning")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(!DataScannerViewController.isSupported)
                
                Spacer()
            }
            .navigationTitle("Scanner")
            .sheet(isPresented: $isShowingScanner) {
                DataScannerRepresentable { isbn in
                    scannedISBN = isbn
                    isShowingScanner = false
                    showingScanResult = true
                }
            }
            .sheet(isPresented: $showingScanResult) {
                if let isbn = scannedISBN {
                    ScanResultSheet(isbn: isbn)
                }
            }
        }
    }
}

// MARK: - DataScannerRepresentable

struct DataScannerRepresentable: UIViewControllerRepresentable {
    let onISBNFound: (String) -> Void
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.ean13, .ean8])],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onISBNFound: onISBNFound)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let onISBNFound: (String) -> Void
        
        init(onISBNFound: @escaping (String) -> Void) {
            self.onISBNFound = onISBNFound
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            if case let .barcode(barcode) = item {
                if let isbn = barcode.payloadStringValue {
                    onISBNFound(isbn)
                }
            }
        }
    }
} 