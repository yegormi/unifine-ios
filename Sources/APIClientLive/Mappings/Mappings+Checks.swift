import APIClient
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import OSLog
import SharedModels

private let logger = Logger(subsystem: "APIClientLive", category: "Mappings+Checks")

extension Components.Schemas.CheckDto {
    func toDomain() -> Check {
        Check(
            id: self.id,
            prompt: self.prompt,
            title: self.title,
            summary: self.summary,
            aiScore: self.aiScore,
            issues: self.issues.map { $0.toDomain() },
            createdAt: self.createdAt
        )
    }
}

extension Components.Schemas.IssueDto {
    func toDomain() -> Check.Issue {
        Check.Issue(
            id: self.id,
            type: Check.Issue.IssueType(rawValue: self._type) ?? .grammar,
            text: self.text,
            message: self.message,
            suggestion: self.suggestion,
            startIndex: Int(self.startIndex),
            endIndex: Int(self.endIndex)
        )
    }
}

extension Components.Schemas.CheckPreviewDto {
    func toDomain() -> CheckPreview {
        CheckPreview(
            id: self.id,
            title: self.title,
            summary: self.summary,
            createdAt: self.createdAt
        )
    }
}

struct DataConversionError: Error {}

extension CreateCheckRequest {
    func toMultipartForm() throws -> MultipartBody<Components.Schemas.CreateCheckDto> {
        let parts = MultipartFormBuilder()
            .append(topic, transform: makeTopicPart)
            .append(style, transform: makeStylePart)
            .append(excludedWords, transform: makeExcludedWordsPart)
            .append(prompt, transform: makePromptPart)
            .appendIfPresent(file, transform: makeFilePart)
            .build()

        return MultipartBody(parts)
    }
}

// MARK: - Private Helpers

private extension CreateCheckRequest {
    func makeTopicPart(_ text: String) -> MultipartBody<Components.Schemas.CreateCheckDto>.Element {
        guard !text.isEmpty, let data = text.data(using: .utf8) else {
            return .topic(.init(payload: .init(body: .init())))
        }
        return .topic(.init(payload: .init(body: .init(data))))
    }

    func makeStylePart(_ text: String) -> MultipartBody<Components.Schemas.CreateCheckDto>.Element {
        guard !text.isEmpty, let data = text.data(using: .utf8) else {
            return .style(.init(payload: .init(body: .init())))
        }
        return .style(.init(payload: .init(body: .init(data))))
    }

    func makeExcludedWordsPart(_ text: String) -> MultipartBody<Components.Schemas.CreateCheckDto>.Element {
        guard !text.isEmpty, let data = text.data(using: .utf8) else {
            return .excludedWords(.init(payload: .init(body: .init())))
        }
        return .excludedWords(.init(payload: .init(body: .init(data))))
    }

    func makePromptPart(_ text: String) -> MultipartBody<Components.Schemas.CreateCheckDto>.Element {
        guard !text.isEmpty, let data = text.data(using: .utf8) else {
            return .prompt(.init(payload: .init(body: .init())))
        }
        return .prompt(.init(payload: .init(body: .init(data))))
    }

    func makeFilePart(_ fileData: Data) -> MultipartBody<Components.Schemas.CreateCheckDto>.Element {
        .file(.init(payload: .init(body: .init(fileData)), filename: "file.pdf"))
    }
}

// MARK: - MultipartFormBuilder

private class MultipartFormBuilder {
    private var parts: [MultipartBody<Components.Schemas.CreateCheckDto>.Element] = []

    @discardableResult
    func append(
        _ value: String,
        transform: (String) -> MultipartBody<Components.Schemas.CreateCheckDto>.Element
    ) -> Self {
        self.parts.append(transform(value))
        return self
    }

    @discardableResult
    func append(
        _ value: String?,
        transform: (String) -> MultipartBody<Components.Schemas.CreateCheckDto>.Element
    ) -> Self {
        self.parts.append(transform(value ?? ""))
        return self
    }

    @discardableResult
    func appendIfPresent(
        _ value: Data?,
        transform: (Data) -> MultipartBody<Components.Schemas.CreateCheckDto>.Element
    ) -> Self {
        if let value {
            self.parts.append(transform(value))
        }
        return self
    }

    func build() -> [MultipartBody<Components.Schemas.CreateCheckDto>.Element] {
        self.parts
    }
}
