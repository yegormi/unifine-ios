import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    let types: [UTType]
    let allowsMultipleSelection: Bool
    let onCancel: (() -> Void)?
    let completion: (Result<[FileAttachment], Error>) -> Void

    init(
        types: [UTType],
        allowsMultipleSelection: Bool = false,
        onCancel: (() -> Void)? = nil,
        completion: @escaping (Result<[FileAttachment], Error>) -> Void
    ) {
        self.types = types
        self.allowsMultipleSelection = allowsMultipleSelection
        self.completion = completion
        self.onCancel = onCancel
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: self.completion, onCancel: self.onCancel)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.allowsMultipleSelection = self.allowsMultipleSelection
        picker.shouldShowFileExtensions = true
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIDocumentPickerViewController, context _: Context) {
        // No need to update anything here
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let completion: (Result<[FileAttachment], Error>) -> Void
        let onCancel: (() -> Void)?

        init(completion: @escaping (Result<[FileAttachment], Error>) -> Void, onCancel: (() -> Void)?) {
            self.completion = completion
            self.onCancel = onCancel
        }

        func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let result = self.readFiles(from: urls)
            self.completion(result)
        }

        private func readFiles(from urls: [URL]) -> Result<[FileAttachment], Error> {
            var files: [FileAttachment] = []

            do {
                for url in urls {
                    guard url.startAccessingSecurityScopedResource() else {
                        return .failure(DocumentPickerError.accessDenied)
                    }

                    defer {
                        url.stopAccessingSecurityScopedResource()
                    }

                    let data = try Data(contentsOf: url)
                    if let attachment = FileAttachment(url: url, data: data) {
                        files.append(attachment)
                    } else {
                        return .failure(DocumentPickerError.invalidFile)
                    }
                }
                return .success(files)
            } catch {
                return .failure(error)
            }
        }
    }
}

enum DocumentPickerError: LocalizedError {
    case accessDenied
    case invalidFile

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            "Failed to access the selected file"
        case .invalidFile:
            "Invalid file format"
        }
    }
}
