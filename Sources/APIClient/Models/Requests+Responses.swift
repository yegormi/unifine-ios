import Foundation
import SharedModels

public struct SignupRequest: Sendable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct LoginRequest: Sendable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct AuthResponse: Sendable {
    public let accessToken: String
    public let user: User
    
    public init(accessToken: String, user: User) {
        self.accessToken = accessToken
        self.user = user
    }
}

public extension AuthResponse {
    static var mock: Self {
        AuthResponse(accessToken: "mock", user: .mock)
    }
}

public struct CreateCheckRequest: Sendable {
    public let topic: String
    public let style: String
    public let excludedWords: String
    public let prompt: String
    public let file: Data
    
    public init(
        topic: String,
        style: String,
        excludedWords: String,
        prompt: String,
        file: Data
    ) {
        self.topic = topic
        self.style = style
        self.excludedWords = excludedWords
        self.prompt = prompt
        self.file = file
    }
}
