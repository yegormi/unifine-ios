import APIClient
import Foundation
import SharedModels

public extension CreateCheckRequest {
    /// Creates a new request with the provided prompt text
    /// - Parameter text: The text to be used as prompt
    /// - Returns: A new CreateCheckRequest with the updated prompt
    func withPromptText(_ text: String) -> CreateCheckRequest {
        CreateCheckRequest(
            topic: self.topic,
            style: self.style,
            excludedWords: self.excludedWords,
            prompt: text,
            file: self.file
        )
    }

    /// Creates a new request with the provided file data
    /// - Parameter fileAttachment: The file attachment containing the data
    /// - Returns: A new CreateCheckRequest with the updated file data
    func withFile(_ fileAttachment: FileAttachment) -> CreateCheckRequest {
        CreateCheckRequest(
            topic: self.topic,
            style: self.style,
            excludedWords: self.excludedWords,
            prompt: self.prompt,
            file: fileAttachment.data
        )
    }
}
