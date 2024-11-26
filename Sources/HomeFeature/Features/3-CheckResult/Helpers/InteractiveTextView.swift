import Foundation
import SharedModels
import SwiftUI

// MARK: - Text Normalization

private extension String {
    func normalizeQuotes() -> String {
        let quoteReplacements: [(String, String)] = [
            ("\"", "'"), // Standard double quote
            ("\"", "'"), // Left double quote
            ("\"", "'"), // Right double quote
            ("″", "'"), // Prime double quote
            ("„", "'"), // Double low-9 quotation mark
        ]

        var result = self
        for (doubleQuote, singleQuote) in quoteReplacements {
            result = result.replacingOccurrences(of: doubleQuote, with: String(singleQuote))
        }
        return result
    }
}

// MARK: - Main View

struct InteractiveTextView: UIViewRepresentable {
    // MARK: - Properties

    private let check: Check
    private let onIssueTapped: (Check.Issue) -> Void
    private let shouldNormalizeQuotes: Bool

    // MARK: - Initialization

    init(
        check: Check,
        onIssueTapped: @escaping (Check.Issue) -> Void,
        shouldNormalizeQuotes: Bool = true
    ) {
        self.check = check
        self.onIssueTapped = onIssueTapped
        self.shouldNormalizeQuotes = shouldNormalizeQuotes
    }

    // MARK: - UIViewRepresentable

    func makeCoordinator() -> Coordinator {
        Coordinator(check: self.check, onIssueTapped: self.onIssueTapped)
    }

    func makeUIView(context: Context) -> UITextView {
        // Create the text storage first
        let textStorage = NSTextStorage()

        // Create and configure the layout manager
        let layoutManager = RoundedBackgroundLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        // Create and configure the text container
        let textContainer = NSTextContainer(size: .zero)
        layoutManager.addTextContainer(textContainer)

        // Create and configure the text view
        let textView = UITextView(frame: .zero, textContainer: textContainer)
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.linkTextAttributes = [:]
        textView.delegate = context.coordinator

        return textView
    }

    func updateUIView(_ textView: UITextView, context _: Context) {
        textView.textStorage.setAttributedString(self.createAttributedString())
    }

    // MARK: - Private Helpers

    private func createAttributedString() -> NSAttributedString {
        let normalizedPrompt = self.shouldNormalizeQuotes ? self.check.prompt.normalizeQuotes() : self.check.prompt
        let attributedString = NSMutableAttributedString(
            string: normalizedPrompt,
            attributes: TextAttributes.default
        )

        let sortedIssues = self.check.issues.sorted { $0.text.count > $1.text.count }
        sortedIssues.forEach { issue in
            self.applyIssueHighlight(issue, to: attributedString)
        }

        return attributedString
    }

    private func applyIssueHighlight(_ issue: Check.Issue, to attributedString: NSMutableAttributedString) {
        let normalizedIssueText = self.shouldNormalizeQuotes ? issue.text.normalizeQuotes() : issue.text
        guard let matches = findMatches(for: normalizedIssueText) else { return }

        if let bestMatch = findBestMatch(matches: matches, originalStartIndex: issue.startIndex) {
            attributedString.addAttributes(
                TextAttributes.highlight(for: issue),
                range: bestMatch.range
            )
        }
    }

    private func findMatches(for text: String) -> [NSTextCheckingResult]? {
        let pattern = NSRegularExpression.escapedPattern(for: text)
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsString = self.shouldNormalizeQuotes ? self.check.prompt.normalizeQuotes() as NSString : self.check
            .prompt as NSString
        return regex?.matches(
            in: nsString as String,
            options: [],
            range: NSRange(location: 0, length: nsString.length)
        )
    }

    private func findBestMatch(
        matches: [NSTextCheckingResult],
        originalStartIndex: Int
    ) -> NSTextCheckingResult? {
        guard matches.count > 1 else { return matches.first }

        return matches.min { match1, match2 in
            abs(match1.range.location - originalStartIndex) <
                abs(match2.range.location - originalStartIndex)
        }
    }
}

// MARK: - TextAttributes

private enum TextAttributes {
    @MainActor static let `default`: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16),
        .foregroundColor: UIColor(Color.grayPrimary),
    ]

    static func highlight(for issue: Check.Issue) -> [NSAttributedString.Key: Any] {
        let foregroundColor = UIColor(issue.type.foreground)
        return [
            .backgroundColor: UIColor(issue.type.background),
            .link: issue.id,
            .foregroundColor: foregroundColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: foregroundColor,
        ]
    }
}

// MARK: - Coordinator

extension InteractiveTextView {
    final class Coordinator: NSObject, UITextViewDelegate {
        private let check: Check
        private let onIssueTapped: (Check.Issue) -> Void

        init(check: Check, onIssueTapped: @escaping (Check.Issue) -> Void) {
            self.check = check
            self.onIssueTapped = onIssueTapped
            super.init()
        }

        func textView(
            _: UITextView,
            shouldInteractWith url: URL,
            in _: NSRange,
            interaction _: UITextItemInteraction
        ) -> Bool {
            guard let issue = check.issues.first(where: { $0.id == url.absoluteString }) else {
                return true
            }
            self.onIssueTapped(issue)
            return false
        }
    }
}

// MARK: - RoundedBackgroundLayoutManager

final class RoundedBackgroundLayoutManager: NSLayoutManager {
    private let cornerRadius: CGFloat = 4

    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        enumerateLineFragments(forGlyphRange: glyphsToShow) { [weak self] _, _, textContainer, glyphRange, _ in
            guard let self else { return }

            let characterRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)

            self.textStorage?.enumerateAttribute(.backgroundColor, in: characterRange, options: []) { value, range, _ in
                guard let bgColor = value as? UIColor else { return }

                let glyphRange = self.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                let boundingRect = self.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                let path = UIBezierPath(
                    roundedRect: boundingRect.offsetBy(dx: origin.x, dy: origin.y),
                    cornerRadius: self.cornerRadius
                )
                bgColor.setFill()
                path.fill()
            }
        }
    }
}
