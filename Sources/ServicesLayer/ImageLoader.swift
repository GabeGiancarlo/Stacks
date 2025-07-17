//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation
import UIKit

// MARK: - ImageLoader

public class ImageLoader: ObservableObject {
    public static let shared = ImageLoader()
    
    private let cache: URLCache
    private let session: URLSession
    
    private init() {
        // Configure cache with 50MB memory and 100MB disk capacity
        cache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,  // 50MB
            diskCapacity: 100 * 1024 * 1024,   // 100MB
            diskPath: "image_cache"
        )
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        session = URLSession(configuration: configuration)
    }
    
    public func loadImage(from url: URL) async throws -> UIImage {
        // Check cache first
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let cachedResponse = cache.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            return image
        }
        
        // Download if not cached
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ImageLoaderError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.invalidImageData
        }
        
        // Cache the response
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: request)
        
        return image
    }
    
    public func clearCache() {
        cache.removeAllCachedResponses()
    }
    
    public func cacheSize() -> (memory: Int, disk: Int) {
        return (
            memory: cache.currentMemoryUsage,
            disk: cache.currentDiskUsage
        )
    }
}

// MARK: - ImageLoaderError

public enum ImageLoaderError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidImageData
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidImageData:
            return "Invalid image data"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Convenience Extensions

public extension ImageLoader {
    func preloadImages(urls: [URL]) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                group.addTask {
                    try? await self.loadImage(from: url)
                }
            }
        }
    }
} 