import APIClient
import ComposableArchitecture
import Foundation
import SharedModels
import Styleguide
import SwiftHelpers
import SwiftUI
import SwiftUIHelpers

@ViewAction(for: CheckResult.self)
public struct CheckResultView: View {
    @Bindable public var store: StoreOf<CheckResult>

    public init(store: StoreOf<CheckResult>) {
        self.store = store
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("AI generation probability is " + String(format: "%.2f", self.store.check.aiScore) + "%")
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(.primary)
                .underline()

            InteractiveTextView(check: self.store.check) { issue in
                send(.issueTapped(issue))
            }
            .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 1)
            )

            Spacer()

            Button {
                send(.plagiarismCheckTapped)
            } label: {
                HStack {
                    if self.store.isChecking {
                        ProgressView()
                    }
                    Text("Plagiarism check")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .disabled(self.store.isChecking)
            .buttonStyle(.primary(size: .fullWidth))
        }
        .padding(.horizontal, 20)
        .sheet(
            item: self.$store.scope(state: \.destination?.issueDetail, action: \.destination.issueDetail)
        ) { store in
            IssueDetailView(store: store)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(25)
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(40)
        }
        .sheet(
            item: self.$store.scope(state: \.destination?.matchesDetail, action: \.destination.matchesDetail)
        ) { store in
            MatchesDetailView(store: store)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .contentMargins(.all, 25, for: .scrollContent)
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(40)
        }
    }
}

#Preview {
    CheckResultView(
        store: Store(initialState: CheckResult.State(check: .mockChatO1)) {
            CheckResult()
        }
    )
}
