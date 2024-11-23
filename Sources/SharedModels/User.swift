import Foundation

public struct User: Codable, Sendable, Equatable {
    public let id: String
    public let email: String

    public init(
        id: String,
        email: String
    ) {
        self.id = id
        self.email = email
    }
}

public extension User {
    static var mock: Self {
        User(id: "mock", email: "mock@gmail.com")
    }
}
