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
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ textView: UITextView, context _: Context) {
        let attributedString = NSMutableAttributedString(
            string: check.prompt,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.label,
            ]
        )

        let issues = self.check.issues.sorted { $0.startIndex < $1.startIndex }

        for issue in issues {
            let range = NSRange(location: issue.startIndex, length: issue.endIndex - issue.startIndex)

            // Add background highlight
            attributedString.addAttribute(
                .backgroundColor,
                value: UIColor(issue.type.color),
                range: range
            )

            // Make tappable
            attributedString.addAttribute(
                .link,
                value: issue.id,
                range: range
            )

            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor(issue.type.foreground),
                range: range
            )

            // Custom link appearance
            attributedString.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: UIColor(issue.type.foreground),
                .foregroundColor: UIColor(issue.type.foreground),
            ], range: range)
        }

        textView.attributedText = attributedString
//        textView.linkTextAttributes = [
//            .foregroundColor: UIColor(Color.black),
//            .underlineStyle: NSUnderlineStyle.single.rawValue,
//        ]
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
