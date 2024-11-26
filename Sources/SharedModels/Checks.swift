import Foundation

// MARK: - Check Models

public struct Check: Sendable, Equatable, Identifiable {
    public struct Issue: Sendable, Equatable, Identifiable {
        public enum IssueType: String, Equatable, Sendable, Codable {
            case grammar
            case vocabulary
            case style
            case tone
        }

        public let id: String
        public let type: IssueType
        public let text: String
        public let message: String
        public let suggestion: String
        public let startIndex: Int
        public let endIndex: Int

        public init(
            id: String,
            type: IssueType,
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
    public let aiScore: Double
    public let issues: [Issue]
    public let createdAt: Date

    public init(
        id: String,
        prompt: String,
        title: String,
        summary: String,
        aiScore: Double,
        issues: [Issue],
        createdAt: Date
    ) {
        self.id = id
        self.prompt = prompt
        self.title = title
        self.summary = summary
        self.aiScore = aiScore
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
        type: .grammar,
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
        aiScore: 99.9,
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

// Create extension for mocking
public extension Check {
    static let mockChatO1 = Check(
        id: UUID().uuidString,
        prompt: """
        Hello,
        My name is Susan. I'm forteen and I life in Germany. My hobbys are go to discos, sometimes I hear music in the radio. In the summer I go bathing in a lake. I haven't any brothers or sisters. We take busses to scool. I visit year 9 at my school. My birthday is on Friday. I hope I will become a new guitar.
        I'm looking forward to get a e-mail from you.

        Yours,
        Susan
        """,
        title: "Introduction Letter from Susan",
        summary: "Susan, a fourteen-year-old girl from Germany, introduces herself by sharing her hobbies, family situation, school life, and her upcoming birthday wish for a new guitar.",
        aiScore: 78.0,
        issues: [
            .init(
                id: UUID().uuidString,
                type: .vocabulary,
                text: "forteen",
                message: "The word 'forteen' is misspelled.",
                suggestion: "fourteen",
                startIndex: 29,
                endIndex: 35
            ),
            .init(
                id: UUID().uuidString,
                type: .grammar,
                text: "I life in Germany.",
                message: "Incorrect verb 'life' used instead of 'live'.",
                suggestion: "I live in Germany.",
                startIndex: 40,
                endIndex: 57
            ),
            .init(
                id: UUID().uuidString,
                type: .vocabulary,
                text: "hobbys",
                message: "The plural of 'hobby' is 'hobbies'.",
                suggestion: "hobbies",
                startIndex: 63,
                endIndex: 68
            ),
            .init(
                id: UUID().uuidString,
                type: .grammar,
                text: "are go to discos",
                message: "Incorrect verb form.",
                suggestion: "are going to discos",
                startIndex: 69,
                endIndex: 85
            ),
            .init(
                id: UUID().uuidString,
                type: .grammar,
                text: "hear music in the radio.",
                message: "Incorrect preposition 'in' used with 'radio'.",
                suggestion: "listen to music on the radio.",
                startIndex: 100,
                endIndex: 123
            ),
            .init(
                id: UUID().uuidString,
                type: .vocabulary,
                text: "go bathing in a lake.",
                message: "Uncommon expression 'go bathing'.",
                suggestion: "go swimming in a lake.",
                startIndex: 141,
                endIndex: 160
            ),
            .init(
                id: UUID().uuidString,
                type: .grammar,
                text: "I haven't any brothers or sisters.",
                message: "Incorrect negative form.",
                suggestion: "I don't have any brothers or sisters.",
                startIndex: 163,
                endIndex: 196
            ),
            .init(
                id: UUID().uuidString,
                type: .vocabulary,
                text: "busses",
                message: "The plural of 'bus' is 'buses'.",
                suggestion: "buses",
                startIndex: 206,
                endIndex: 211
            ),
            .init(
                id: UUID().uuidString,
                type: .vocabulary,
                text: "scool",
                message: "The word 'scool' is misspelled.",
                suggestion: "school.",
                startIndex: 216,
                endIndex: 221
            ),
            .init(
                id: UUID().uuidString,
                type: .grammar,
                text: "I visit year 9 at my school.",
                message: "Incorrect verb 'visit' used.",
                suggestion: "I am in year 9 at my school.",
                startIndex: 223,
                endIndex: 250
            ),
            .init(
                id: UUID().uuidString,
                type: .grammar,
                text: "I hope I will become a new guitar.",
                message: "Incorrect verb 'become' used.",
                suggestion: "I hope I will get a new guitar.",
                startIndex: 278,
                endIndex: 311
            ),
            .init(
                id: UUID().uuidString,
                type: .grammar,
                text: "looking forward to get a e-mail from you.",
                message: "Incorrect verb form after 'looking forward to'.",
                suggestion: "looking forward to getting an email from you.",
                startIndex: 316,
                endIndex: 357
            ),
            .init(
                id: UUID().uuidString,
                type: .style,
                text: "e-mail",
                message: "Hyphenated 'e-mail' is less common.",
                suggestion: "email",
                startIndex: 342,
                endIndex: 347
            ),
            .init(
                id: UUID().uuidString,
                type: .style,
                text: "Yours,",
                message: "Closing may be more complete with 'sincerely'.",
                suggestion: "Yours sincerely,",
                startIndex: 360,
                endIndex: 366
            ),
        ],
        createdAt: Date()
    )

    static let mockReal = Check(
        id: "check_47891",
        prompt: """
        Please review my email to a potential client:

        Dear Mr. Johnson,

        I wanted to reach out about the software development project we discussed last week. Our team has reviwed the requirements and we're confident we can deliver the solution within your timeframe. We can definately meet all your specifications and ensure top-notch quality.

        We would love to setup a meeting next week to discuss the project in more detail. Let me know what time works best for you're schedule.

        Looking forward to your response!

        Best regards,
        Sarah
        """,
        title: "Professional Email Review",
        summary: "The email maintains a professional tone but contains several grammatical errors and could benefit from more formal language choices. Consider implementing the suggested corrections to enhance clarity and professionalism.",
        aiScore: 99.9,
        issues: [
            Issue(
                id: "issue_1",
                type: .grammar,
                text: "reviwed",
                message: "Spelling error in 'reviwed'",
                suggestion: "reviewed",
                startIndex: 162,
                endIndex: 169
            ),
            Issue(
                id: "issue_2",
                type: .grammar,
                text: "definately",
                message: "Common spelling error",
                suggestion: "definitely",
                startIndex: 189,
                endIndex: 199
            ),
            Issue(
                id: "issue_3",
                type: .vocabulary,
                text: "setup",
                message: "'setup' is a noun; use 'set up' as a verb phrase",
                suggestion: "set up",
                startIndex: 264,
                endIndex: 269
            ),
            Issue(
                id: "issue_4",
                type: .grammar,
                text: "you're",
                message: "Incorrect use of 'you're' (contraction of 'you are')",
                suggestion: "your",
                startIndex: 345,
                endIndex: 350
            ),
            Issue(
                id: "issue_5",
                type: .tone,
                text: "Looking forward to your response!",
                message: "Consider a more professional closing line",
                suggestion: "I look forward to your response.",
                startIndex: 353,
                endIndex: 384
            ),
            Issue(
                id: "issue_6",
                type: .style,
                text: "wanted to reach out",
                message: "Indirect phrasing can be simplified",
                suggestion: "I am writing",
                startIndex: 67,
                endIndex: 85
            ),
        ],
        createdAt: Date(timeIntervalSinceNow: -3600) // 1 hour ago
    )

    // Additional mock for different context
    static let mockAcademic = Check(
        id: "check_47892",
        prompt: """
        The study reveeled significant correlations between sleep patterns and academic performance. Students who maintaned consistent sleep schedules showed a 15% increase in test scores, while those with irratic sleep patterns demonstrated decreased performance. This data suggests that proper sleep habits effect academic success.
        """,
        title: "Academic Writing Review",
        summary: "The paragraph presents important research findings but contains several spelling and grammatical errors that should be corrected. Consider restructuring certain phrases for better academic tone.",
        aiScore: 99.9,
        issues: [
            Issue(
                id: "issue_7",
                type: .grammar,
                text: "reveeled",
                message: "Spelling error in 'reveeled'",
                suggestion: "revealed",
                startIndex: 25,
                endIndex: 33
            ),
            Issue(
                id: "issue_8",
                type: .grammar,
                text: "maintaned",
                message: "Spelling error in 'maintaned'",
                suggestion: "maintained",
                startIndex: 89,
                endIndex: 98
            ),
            Issue(
                id: "issue_9",
                type: .grammar,
                text: "irratic",
                message: "Spelling error in 'irratic'",
                suggestion: "erratic",
                startIndex: 165,
                endIndex: 172
            ),
            Issue(
                id: "issue_10",
                type: .grammar,
                text: "effect",
                message: "Incorrect use of 'effect' (noun) instead of 'affect' (verb)",
                suggestion: "affect",
                startIndex: 241,
                endIndex: 247
            ),
            Issue(
                id: "issue_11",
                type: .style,
                text: "This data suggests",
                message: "Consider more precise academic phrasing",
                suggestion: "These findings indicate",
                startIndex: 219,
                endIndex: 235
            ),
            Issue(
                id: "issue_12",
                type: .tone,
                text: "showed a 15% increase",
                message: "Consider more formal academic phrasing",
                suggestion: "demonstrated a 15% improvement",
                startIndex: 108,
                endIndex: 127
            ),
        ],
        createdAt: Date(timeIntervalSinceNow: -7200) // 2 hours ago
    )
}

public extension Check {
    static let mockTechnical = Check(
        id: "check_1",
        prompt: """
        The implentation of machine learning algorithms in modern software development has revolutionized how we approach problem solving. Traditional methods are now being replaced by more sophisticated neural networks that can proces vast amounts of data and extract patterns. These systems excell at tasks such as natural language processing and computer vision, althought it is worth noting that they still face challanges in production environments.
        """,
        title: "Analysis of Technical Writing Sample",
        summary: "The text discusses the impact of machine learning algorithms on software development but contains several spelling errors, passive voice constructions, and could benefit from more precise vocabulary.",
        aiScore: 99.9,
        issues: [
            Issue(
                id: "issue_1",
                type: .grammar, // grammar, vocabulary, style, or tone
                text: "implentation",
                message: "The word 'implentation' is misspelled.",
                suggestion: "Correct it to 'implementation'.",
                startIndex: 4,
                endIndex: 15
            ),
            Issue(
                id: "issue_2",
                type: .vocabulary,
                text: "revolutionized",
                message: "The word 'revolutionized' might be too strong in this context.",
                suggestion: "Consider using 'transformed' or 'significantly influenced' instead.",
                startIndex: 85,
                endIndex: 99
            ),
            Issue(
                id: "issue_3",
                type: .style,
                text: "Traditional methods are now being replaced by more sophisticated neural networks",
                message: "This sentence uses passive voice.",
                suggestion: "Rephrase to active voice: 'More sophisticated neural networks are now replacing traditional methods.'",
                startIndex: 133,
                endIndex: 213
            ),
            Issue(
                id: "issue_4",
                type: .tone,
                text: "it is worth noting that",
                message: "The phrase 'it is worth noting that' is wordy and may affect the formal tone.",
                suggestion: "Consider omitting it or using 'notably' for conciseness.",
                startIndex: 370,
                endIndex: 393
            ),
        ],
        createdAt: Date(timeIntervalSinceNow: 0) // now
    )
    /* Verify your indices by listing them:
     implentation[4-15]
     revolutionized[85-99]
     Traditional methods are now being replaced by more sophisticated neural networks[133-213]
     it is worth noting that[370-393]
     */
}
