import Foundation
import AVFoundation
import Combine

@MainActor
class ScannerViewModel: NSObject, ObservableObject {
    @Published var hasPermission = false
    @Published var showBookFound = false
    @Published var scannedBook: Book?
    
    let captureSession = AVCaptureSession()
    private var metadataOutput = AVCaptureMetadataOutput()
    private let libraryService = LibraryService.shared
    
    override init() {
        super.init()
        checkPermission()
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            hasPermission = true
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor in
                    self?.hasPermission = granted
                    if granted {
                        self?.setupCamera()
                    }
                }
            }
        default:
            hasPermission = false
        }
    }
    
    func setupCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                return
            }
            
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean13, .ean8, .code128]
            } else {
                return
            }
        } catch {
            return
        }
    }
    
    func startScanning() {
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
    
    func stopScanning() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func addScannedBook() async {
        guard let book = scannedBook else { return }
        
        do {
            _ = try await libraryService.addBook(
                isbn: book.isbn,
                title: book.title,
                author: book.author,
                description: book.description,
                publishedYear: book.publishedYear,
                coverImageData: nil
            )
        } catch {
            // Handle error
        }
    }
}

extension ScannerViewModel: AVCaptureMetadataOutputObjectsDelegate {
    nonisolated func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue else {
            return
        }
        
        Task { @MainActor in
            // Stop scanning
            stopScanning()
            
            // Lookup book by ISBN (simplified - in production, use OpenLibrary or Google Books API)
            // For now, create a placeholder book
            scannedBook = Book(
                id: 0,
                isbn: stringValue,
                title: "Scanned Book",
                author: "Unknown Author",
                coverUrl: nil,
                description: nil,
                publishedYear: nil,
                status: nil,
                addedAt: nil
            )
            
            showBookFound = true
        }
    }
}

