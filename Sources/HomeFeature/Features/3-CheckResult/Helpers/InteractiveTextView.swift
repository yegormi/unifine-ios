import Foundation
import SharedModels
import SwiftUI

struct InteractiveTextView: UIViewRepresentable {
    let check: Check
    let onIssueTapped: (Check.Issue) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(check: self.check, onIssueTapped: self.onIssueTapped)
    }

    func makeUIView(context: Context) -> UITextView {
        // Create text storage, layout manager, and text container
        let textStorage = NSTextStorage()
        let layoutManager = RoundedBackgroundLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)

        // Configure the layout manager and text container
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Initialize the UITextView with the custom text container
        let textView = UITextView(frame: .zero, textContainer: textContainer)

        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = context.coordinator

        // Disable default link appearance
        textView.linkTextAttributes = [:]

        return textView
    }

    func updateUIView(_ textView: UITextView, context _: Context) {
        let attributedString = NSMutableAttributedString(
            string: check.prompt,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor(Color.grayPrimary),
            ]
        )

        let issues = self.check.issues.sorted { $0.startIndex < $1.startIndex }
        for issue in issues {
            let range = NSRange(location: issue.startIndex, length: issue.endIndex - issue.startIndex)
            let foregroundColor = UIColor(issue.type.foreground)

            // Apply attributes
            attributedString.addAttributes([
                // Background highlight
                .backgroundColor: UIColor(issue.type.background),
                // Link for tap handling
                .link: issue.id,
                // Text styling
                .foregroundColor: foregroundColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: foregroundColor,
            ], range: range)
        }

        // Update the text storage's attributed string
        textView.textStorage.setAttributedString(attributedString)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        let check: Check
        let onIssueTapped: (Check.Issue) -> Void

        init(check: Check, onIssueTapped: @escaping (Check.Issue) -> Void) {
            self.check = check
            self.onIssueTapped = onIssueTapped
        }

        func textView(
            _: UITextView,
            shouldInteractWith URL: URL,
            in _: NSRange,
            interaction _: UITextItemInteraction
        ) -> Bool {
            if let issue = self.check.issues.first(where: { $0.id == URL.absoluteString }) {
                self.onIssueTapped(issue)
                return false
            }
            return true
        }
    }
}

// Custom NSLayoutManager to draw rounded background
class RoundedBackgroundLayoutManager: NSLayoutManager {
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        // Enumerate through all glyphs in the specified range
        self.enumerateLineFragments(forGlyphRange: glyphsToShow) { _, _, textContainer, glyphRange, _ in
            // Get the character range for the glyph range
            let characterRange = self.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)

            // Enumerate through all background color attributes in the character range
            self.textStorage?.enumerateAttribute(.backgroundColor, in: characterRange, options: []) { value, range, _ in
                if let bgColor = value as? UIColor {
                    // Get the glyph range for the character range
                    let glyphRange = self.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                    // Get the bounding rectangle for the glyph range
                    let boundingRect = self.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                    // Create a path with rounded corners
                    let path = UIBezierPath(roundedRect: boundingRect.offsetBy(dx: origin.x, dy: origin.y), cornerRadius: 4)
                    // Set the fill color and fill the path
                    bgColor.setFill()
                    path.fill()
                }
            }
        }
    }
}
