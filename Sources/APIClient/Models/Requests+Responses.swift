import Foundation
import SharedModels

public struct AuthRequest: Sendable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
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
