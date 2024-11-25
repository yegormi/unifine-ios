import Foundation
import UniformTypeIdentifiers

extension URL {
    var mimeType: String? {
        let pathExtension = self.pathExtension
        if let uti = UTType(filenameExtension: pathExtension) {
            return uti.preferredMIMEType
        }
        return nil
    }
}
