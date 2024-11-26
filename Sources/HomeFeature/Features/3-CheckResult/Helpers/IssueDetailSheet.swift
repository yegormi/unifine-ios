import Foundation
import SharedModels
import SwiftUI

struct IssueDetailSheet: View {
    let issue: Check.Issue

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Suggestion")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(Color.primary)

            VStack(alignment: .leading, spacing: 8) {
                Text(self.issue.type.rawValue.capitalized)
                    .foregroundStyle(Color.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(self.issue.type.color))
                    )
                    .font(.system(size: 12, weight: .regular))
                Text(self.issue.message)
                    .foregroundStyle(.gray)
                    .font(.system(size: 18, weight: .regular))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Fixed")
                    .foregroundStyle(Color.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(Color.greenPrimary))
                    )
                    .font(.system(size: 12, weight: .regular))
                Text(self.issue.suggestion)
                    .foregroundStyle(.gray)
                    .font(.system(size: 18, weight: .regular))
            }

            Spacer()
        }
    }
}
