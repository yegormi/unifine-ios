import APIClient
import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers
import UniformTypeIdentifiers

@ViewAction(for: CheckResult.self)
public struct CheckResultView: View {
    @Bindable public var store: StoreOf<CheckResult>

    public init(store: StoreOf<CheckResult>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
//                titleSection
                self.highlightedTextSection
                self.issuesSection
            }
        }
        .padding()
    }

    // MARK: - View Components

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.store.check.title)
                .font(.title2)
                .fontWeight(.bold)

            Text(self.store.check.summary)
                .foregroundStyle(.secondary)
        }
    }

    private var highlightedTextSection: some View {
        ScrollView {
            Text(self.attributedText())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.1))
                )
        }
    }

    private var issuesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Issues")
                .font(.headline)

            self.issuesList
        }
    }

    private var issuesList: some View {
        ForEach(self.store.check.issues) { issue in
            IssueCard(
                issue: issue,
                isSelected: self.store.selectedIssue?.id == issue.id,
                color: self.color(for: issue.type)
            )
            .onTapGesture {
                send(.issueSelected(issue))
            }
        }
    }

    // MARK: - Helper Functions

    private func color(for type: Check.Issue.IssueType) -> Color {
        switch type {
        case .grammar:
            .red.opacity(0.3)
        case .vocabulary:
            .blue.opacity(0.3)
        case .style:
            .orange.opacity(0.3)
        case .tone:
            .purple.opacity(0.3)
        }
    }

    private func attributedText() -> AttributedString {
        var text = AttributedString(store.check.prompt)

        let sortedIssues = self.store.check.issues.sorted { $0.startIndex < $1.startIndex }

        for issue in sortedIssues {
            guard issue.startIndex >= 0, issue.endIndex <= text.characters.count else { continue }

            guard let range = range(from: issue.startIndex, to: issue.endIndex, in: text) else { continue }
            text[range].backgroundColor = self.color(for: issue.type)
        }

        return text
    }

    private func index(for offset: Int, in text: AttributedString) -> AttributedString.Index? {
        guard offset >= 0 else { return nil }
        return text.index(text.startIndex, offsetByCharacters: offset)
    }

    private func range(
        from startOffset: Int,
        to endOffset: Int,
        in text: AttributedString
    ) -> Range<AttributedString.Index>? {
        guard
            let start = index(for: startOffset, in: text),
            let end = index(for: endOffset, in: text)
        else { return nil }
        return start ..< end
    }
}

// MARK: - IssueCard View

private struct IssueCard: View {
    let issue: Check.Issue
    let isSelected: Bool
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            self.issueHeader
            self.issueMessage
            if self.isSelected {
                self.issueSuggestion
            }
        }
        .padding()
        .background(
            self.cardBackground
        )
    }

    private var issueHeader: some View {
        HStack {
            Circle()
                .fill(self.color)
                .frame(width: 12, height: 12)

            Text(self.issue.type.rawValue.capitalized)
                .font(.subheadline)
                .fontWeight(.medium)

            Spacer()

            Text("View in text")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var issueMessage: some View {
        Text(self.issue.message)
            .font(.body)
    }

    private var issueSuggestion: some View {
        HStack {
            Text("Suggestion:")
                .font(.subheadline)
                .fontWeight(.medium)

            Text(self.issue.suggestion)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 4)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.secondary.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(self.isSelected ? self.color : Color.clear, lineWidth: 2)
            )
    }
}
