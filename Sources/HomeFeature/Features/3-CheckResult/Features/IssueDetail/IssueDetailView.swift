import APIClient
import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: CheckResult.self)
public struct IssueDetailView: View {
    @Bindable public var store: StoreOf<IssueDetail>

    public init(store: StoreOf<IssueDetail>) {
        self.store = store
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Suggestion")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(Color.primary)

            VStack(alignment: .leading, spacing: 8) {
                Text(self.store.issue.type.rawValue.capitalized)
                    .foregroundStyle(Color.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(self.store.issue.type.color))
                    )
                    .font(.system(size: 12, weight: .regular))
                Text(self.store.issue.message)
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
                Text(self.store.issue.suggestion)
                    .foregroundStyle(.gray)
                    .font(.system(size: 18, weight: .regular))
            }

            Spacer()
        }
    }
}
