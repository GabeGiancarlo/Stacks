//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation
import SwiftUI

// MARK: - ResourceManager

public class ResourceManager {
    public static let shared = ResourceManager()
    
    private init() {}
    
    // MARK: - Asset Loading
    
    public func loadImage(named imageName: String) -> Image? {
        if let uiImage = UIImage(named: imageName, in: Bundle.module, compatibleWith: nil) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    public func placeholderBookCover() -> Image {
        loadImage(named: "placeholder-book-cover") ?? Image(systemName: "book.closed")
    }
    
    public func placeholderAvatar() -> Image {
        loadImage(named: "placeholder-avatar") ?? Image(systemName: "person.circle.fill")
    }
    
    // MARK: - Color Scheme
    
    public var primaryColor: Color {
        Color("PrimaryColor", bundle: Bundle.module) ?? .blue
    }
    
    public var secondaryColor: Color {
        Color("SecondaryColor", bundle: Bundle.module) ?? .gray
    }
    
    public var backgroundColor: Color {
        Color("BackgroundColor", bundle: Bundle.module) ?? Color(.systemBackground)
    }
}

// MARK: - Bundle Extension

private extension Foundation.Bundle {
    static let module: Bundle = {
        let bundleName = "Intitled_Resources"
        
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            
            // Bundle should be present here when the package is used in a Command Line Tool.
            Bundle.main.bundleURL,
            
            // For Swift Package Manager tests.
            Bundle(for: ResourceManager.self).resourceURL,
        ]
        
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        return Bundle(for: ResourceManager.self)
    }()
} 