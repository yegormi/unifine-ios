import SharedModels
import SwiftUI

struct IssueCard: View {
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
