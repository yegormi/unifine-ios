import APIClient
import Foundation
import SharedModels
import OpenAPIRuntime
import OpenAPIURLSession

extension Components.Schemas.CheckDto {
    func toDomain() -> Check {
        Check(
            id: self.id,
            prompt: self.prompt,
            summary: self.summary,
            issues: self.issues.map { $0.toDomain() }
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
            prompt: self.prompt,
            summary: self.summary
        )
    }
}

struct DataConversionError: Error {}

extension CreateCheckRequest {
    func toMultipartForm() throws -> MultipartBody<Components.Schemas.CreateCheckDto> {
        guard let topicData = self.topic.data(using: .utf8),
              let styleData = self.style.data(using: .utf8),
              let excludedWordsData = self.excludedWords.data(using: .utf8),
              let promptData = self.prompt.data(using: .utf8) else {
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
