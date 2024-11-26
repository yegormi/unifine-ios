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
    @State private var showingIssueSheet = false

    public init(store: StoreOf<CheckResult>) {
        self.store = store
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            self.highlightedTextSection

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
            .buttonStyle(.primary(size: .fullWidth))
        }
        .padding(20)
        .sheet(isPresented: self.$showingIssueSheet) {
            if let selectedIssue = store.selectedIssue {
                IssueDetailSheet(issue: selectedIssue)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var highlightedTextSection: some View {
        InteractiveTextView(check: self.store.check) { issue in
            self.showingIssueSheet = true
            send(.issueSelected(issue))
        }
        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
    }
}

#Preview {
    CheckResultView(
        store: Store(initialState: CheckResult.State(check: .mockTechnical)) {
            CheckResult()
        }
    )
}
