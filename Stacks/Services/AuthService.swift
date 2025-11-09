import Foundation

/// Authentication service interface
protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> User
    func signUp(email: String, username: String, password: String) async throws -> User
    func logout() async throws
    func getCurrentUser() async throws -> User?
}

/// Mock authentication service
class MockAuthService: AuthServiceProtocol {
    private var currentUser: User?
    
    func login(email: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock successful login
        let user = User(
            id: 1,
            email: email,
            username: email.components(separatedBy: "@").first ?? "user",
            displayName: "John Doe",
            bio: "Book lover and avid reader",
            avatarURL: nil,
            privacySettings: nil,
            totalBooksRead: 42,
            totalPagesRead: 12500,
            createdAt: Date(),
            updatedAt: Date(),
            lastLoginAt: Date()
        )
        
        currentUser = user
        return user
    }
    
    func signUp(email: String, username: String, password: String) async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock successful signup
        let user = User(
            id: Int.random(in: 100...999),
            email: email,
            username: username,
            displayName: username,
            bio: nil,
            avatarURL: nil,
            privacySettings: nil,
            totalBooksRead: 0,
            totalPagesRead: 0,
            createdAt: Date(),
            updatedAt: Date(),
            lastLoginAt: nil
        )
        
        currentUser = user
        return user
    }
    
    func logout() async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        currentUser = nil
    }
    
    func getCurrentUser() async throws -> User? {
        return currentUser
    }
}

