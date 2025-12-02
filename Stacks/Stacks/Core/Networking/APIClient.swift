import Foundation
import Combine

class APIClient {
    static let shared = APIClient()
    
    private let baseURL: String
    private let keychainManager: KeychainManager
    private let session: URLSession
    
    init(
        baseURL: String? = nil,
        keychainManager: KeychainManager = KeychainManager.shared
    ) {
        #if DEBUG
        self.baseURL = baseURL ?? ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "http://localhost:8080"
        #else
        self.baseURL = baseURL ?? "https://api.stacks-app.com"
        #endif
        
        self.keychainManager = keychainManager
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token if available
        if let accessToken = keychainManager.getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add body
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        #if DEBUG
        print("🌐 \(endpoint.method.rawValue) \(endpoint.path)")
        #endif
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            // Handle 401 - try to refresh token
            if httpResponse.statusCode == 401 {
                if try await refreshTokenIfNeeded() {
                    // Retry original request with new token
                    if let accessToken = keychainManager.getAccessToken() {
                        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                        let (retryData, retryResponse) = try await session.data(for: request)
                        
                        guard let retryHttpResponse = retryResponse as? HTTPURLResponse else {
                            throw NetworkError.unknown
                        }
                        
                        guard (200...299).contains(retryHttpResponse.statusCode) else {
                            throw NetworkError.serverError(
                                retryHttpResponse.statusCode,
                                String(data: retryData, encoding: .utf8)
                            )
                        }
                        
                        return try decodeResponse(data: retryData)
                    }
                }
                throw NetworkError.unauthorized
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8)
                throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
            }
            
            return try decodeResponse(data: data)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    func uploadImage(
        endpoint: Endpoint,
        imageData: Data,
        fieldName: String = "cover",
        additionalFields: [String: String] = [:]
    ) async throws -> Data {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Add auth token
        if let accessToken = keychainManager.getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        var body = Data()
        
        // Add image
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"cover.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add additional fields
        for (key, value) in additionalFields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        if httpResponse.statusCode == 401 {
            if try await refreshTokenIfNeeded() {
                // Retry with new token
                if let accessToken = keychainManager.getAccessToken() {
                    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                    let (retryData, retryResponse) = try await session.data(for: request)
                    
                    guard let retryHttpResponse = retryResponse as? HTTPURLResponse else {
                        throw NetworkError.unknown
                    }
                    
                    guard (200...299).contains(retryHttpResponse.statusCode) else {
                        throw NetworkError.serverError(
                            retryHttpResponse.statusCode,
                            String(data: retryData, encoding: .utf8)
                        )
                    }
                    
                    return retryData
                }
            }
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8)
            throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
        }
        
        return data
    }
    
    private func refreshTokenIfNeeded() async throws -> Bool {
        guard let refreshToken = keychainManager.getRefreshToken() else {
            return false
        }
        
        let endpoint = Endpoint.refreshToken(refreshToken: refreshToken)
        guard let url = URL(string: baseURL + endpoint.path) else {
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = endpoint.body
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            // Refresh failed, clear tokens
            keychainManager.clearTokens()
            return false
        }
        
        struct RefreshResponse: Decodable {
            let accessToken: String
        }
        
        let refreshResponse = try JSONDecoder().decode(RefreshResponse.self, from: data)
        keychainManager.saveAccessToken(refreshResponse.accessToken)
        
        return true
    }
    
    private func decodeResponse<T: Decodable>(data: Data) throws -> T {
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
            return try decoder.decode(T.self, from: data)
        } catch {
            // Try with fallback date format
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        }
    }
}

