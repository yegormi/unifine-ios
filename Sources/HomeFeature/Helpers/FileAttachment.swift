import Foundation

public struct FileAttachment: Equatable, Sendable {
    let name: String
    let fileExtension: String
    let mimeType: String
    let data: Data

    var fullName: String {
        "\(self.name).\(self.fileExtension)"
    }

    init?(url: URL, data: Data) {
        self.name = url.deletingPathExtension().lastPathComponent
        self.fileExtension = url.pathExtension
        self.data = data

        if let mimeType = url.mimeType {
            self.mimeType = mimeType
        } else {
            return nil
        }
    }
}
