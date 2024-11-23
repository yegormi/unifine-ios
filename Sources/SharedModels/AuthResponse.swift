import Foundation

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
