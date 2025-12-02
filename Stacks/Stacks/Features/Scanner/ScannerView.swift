import SwiftUI
import AVFoundation

struct ScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showManualEntry = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.hasPermission {
                    CameraPreview(session: viewModel.captureSession)
                        .ignoresSafeArea()
                    
                    // Overlay with scanning guide
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 16) {
                            Text("Position ISBN barcode within the frame")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)
                            
                            // Scanning frame
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 250, height: 150)
                        }
                        .padding(.bottom, 100)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.secondaryText)
                        
                        Text("Camera Permission Required")
                            .font(.title2)
                            .foregroundColor(.primaryText)
                        
                        Text("Please enable camera access in Settings to scan ISBN barcodes")
                            .font(.body)
                            .foregroundColor(.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Scan Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Manual Entry") {
                        showManualEntry = true
                    }
                }
            }
            .sheet(isPresented: $showManualEntry) {
                ManualBookEntryView()
            }
            .onAppear {
                viewModel.startScanning()
            }
            .onDisappear {
                viewModel.stopScanning()
            }
            .alert("Book Found", isPresented: $viewModel.showBookFound) {
                Button("Add to Library") {
                    Task {
                        await viewModel.addScannedBook()
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                if let book = viewModel.scannedBook {
                    Text("Add \(book.title) by \(book.author) to your library?")
                }
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}

