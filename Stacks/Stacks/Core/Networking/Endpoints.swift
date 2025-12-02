import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let body: Data?
    let headers: [String: String]?
    
    init(
        path: String,
        method: HTTPMethod = .get,
        body: Data? = nil,
        headers: [String: String]? = nil
    ) {
        self.path = path
        self.method = method
        self.body = body
        self.headers = headers
    }
}

extension Endpoint {
    static func signup(email: String, password: String, username: String) -> Endpoint {
        let body = try? JSONEncoder().encode([
            "email": email,
            "password": password,
            "username": username
        ])
        return Endpoint(path: "/api/auth/signup", method: .post, body: body)
    }
    
    static func login(email: String, password: String) -> Endpoint {
        let body = try? JSONEncoder().encode([
            "email": email,
            "password": password
        ])
        return Endpoint(path: "/api/auth/login", method: .post, body: body)
    }
    
    static func refreshToken(refreshToken: String) -> Endpoint {
        let body = try? JSONEncoder().encode([
            "refreshToken": refreshToken
        ])
        return Endpoint(path: "/api/auth/refresh", method: .post, body: body)
    }
    
    static func logout() -> Endpoint {
        return Endpoint(path: "/api/auth/logout", method: .post)
    }
    
    static func getBooks() -> Endpoint {
        return Endpoint(path: "/api/books", method: .get)
    }
    
    static func addBook(isbn: String?, title: String, author: String, description: String?, publishedYear: Int?, coverImageData: Data?) -> Endpoint {
        // For multipart form data, we'll handle this specially in APIClient
        return Endpoint(path: "/api/books", method: .post)
    }
    
    static func getBook(id: Int) -> Endpoint {
        return Endpoint(path: "/api/books/\(id)", method: .get)
    }
    
    static func updateBook(id: Int, title: String?, author: String?, description: String?, publishedYear: Int?, coverImageData: Data?) -> Endpoint {
        return Endpoint(path: "/api/books/\(id)", method: .put)
    }
    
    static func deleteBook(id: Int) -> Endpoint {
        return Endpoint(path: "/api/books/\(id)", method: .delete)
    }
    
    static func createReview(bookId: Int, rating: Int, reviewText: String?) -> Endpoint {
        let body = try? JSONEncoder().encode([
            "rating": rating,
            "reviewText": reviewText ?? ""
        ])
        return Endpoint(path: "/api/books/\(bookId)/reviews", method: .post, body: body)
    }
    
    static func updateReview(id: Int, rating: Int?, reviewText: String?) -> Endpoint {
        var bodyDict: [String: Any] = [:]
        if let rating = rating {
            bodyDict["rating"] = rating
        }
        if let reviewText = reviewText {
            bodyDict["reviewText"] = reviewText
        }
        let body = try? JSONSerialization.data(withJSONObject: bodyDict)
        return Endpoint(path: "/api/reviews/\(id)", method: .put, body: body)
    }
    
    static func deleteReview(id: Int) -> Endpoint {
        return Endpoint(path: "/api/reviews/\(id)", method: .delete)
    }
    
    static func getRecommendations() -> Endpoint {
        return Endpoint(path: "/api/explore/recommendations", method: .get)
    }
    
    static func getProfile() -> Endpoint {
        return Endpoint(path: "/api/users/me", method: .get)
    }
    
    static func getBadges() -> Endpoint {
        return Endpoint(path: "/api/users/me/badges", method: .get)
    }
}

