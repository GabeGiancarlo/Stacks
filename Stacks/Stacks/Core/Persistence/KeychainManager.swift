import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    
    private let accessTokenKey = "com.stacks.accessToken"
    private let refreshTokenKey = "com.stacks.refreshToken"
    private let service = "com.stacks.app"
    
    private init() {}
    
    func saveAccessToken(_ token: String) {
        save(token, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return get(forKey: accessTokenKey)
    }
    
    func saveRefreshToken(_ token: String) {
        save(token, forKey: refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return get(forKey: refreshTokenKey)
    }
    
    func clearTokens() {
        delete(forKey: accessTokenKey)
        delete(forKey: refreshTokenKey)
    }
    
    private func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item first
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

