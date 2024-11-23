import Foundation

// MARK: - Check Models

public struct Check: Sendable, Equatable, Identifiable {
    public struct Issue: Sendable, Equatable, Identifiable {
        public let id: String
        public let type: String
        public let text: String
        public let message: String
        public let suggestion: String
        public let startIndex: Int
        public let endIndex: Int

        public init(
            id: String,
            type: String,
            text: String,
            message: String,
            suggestion: String,
            startIndex: Int,
            endIndex: Int
        ) {
            self.id = id
            self.type = type
            self.text = text
            self.message = message
            self.suggestion = suggestion
            self.startIndex = startIndex
            self.endIndex = endIndex
        }
    }

    public let id: String
    public let prompt: String
    public let title: String
    public let summary: String
    public let issues: [Issue]
    public let createdAt: Date

    public init(
        id: String,
        prompt: String,
        title: String,
        summary: String,
        issues: [Issue],
        createdAt: Date
    ) {
        self.id = id
        self.prompt = prompt
        self.title = title
        self.summary = summary
        self.issues = issues
        self.createdAt = createdAt
    }
}

public struct CheckPreview: Sendable, Equatable, Identifiable {
    public let id: String
    public let title: String
    public let summary: String
    public let createdAt: Date

    public init(
        id: String,
        title: String,
        summary: String,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.createdAt = createdAt
    }
}

// MARK: - Mock Extensions

public extension Check.Issue {
    static let mock = Self(
        id: "mock-issue-id",
        type: "grammar",
        text: "mock issue text",
        message: "This is a mock issue message",
        suggestion: "Here's a mock suggestion",
        startIndex: 0,
        endIndex: 10
    )
}

public extension Check {
    static let mock = Self(
        id: "mock-check-id",
        prompt: "mock prompt",
        title: "mock title",
        summary: "mock summary",
        issues: [.mock],
        createdAt: .now
    )
}

public extension CheckPreview {
    static let mock1 = Self(
        id: "1",
        title: "mock title",
        summary: "mock summary",
        createdAt: .now
    )

    static let mock2 = Self(
        id: "2",
        title: "mock title",
        summary: "mock summary",
        createdAt: .now
    )
}

// MARK: - Hashable Conformance

extension Check.Issue: Hashable {}
extension Check: Hashable {}
extension CheckPreview: Hashable {}

// MARK: - Codable Conformance

extension Check.Issue: Codable {}
extension Check: Codable {}
extension CheckPreview: Codable {}
