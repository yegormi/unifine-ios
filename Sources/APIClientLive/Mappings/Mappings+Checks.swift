import APIClient
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession
import SharedModels

extension Components.Schemas.CheckDto {
    func toDomain() -> Check {
        Check(
            id: self.id,
            prompt: self.prompt,
            title: self.title,
            summary: self.summary,
            issues: self.issues.map { $0.toDomain() },
            createdAt: self.createdAt
        )
    }
}

extension Components.Schemas.IssueDto {
    func toDomain() -> Check.Issue {
        Check.Issue(
            id: self.id,
            type: self._type,
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
        guard
            let topicData = self.topic.data(using: .utf8),
            let styleData = self.style.data(using: .utf8),
            let excludedWordsData = self.excludedWords.data(using: .utf8),
            let prompt, let promptData = prompt.data(using: .utf8)
        else {
            throw DataConversionError()
        }
        return [
            .topic(.init(payload: .init(body: .init(topicData)))),
            .style(.init(payload: .init(body: .init(styleData)))),
            .excludedWords(.init(payload: .init(body: .init(excludedWordsData)))),
            .prompt(.init(payload: .init(body: .init(promptData)))),
        ]
    }
}
